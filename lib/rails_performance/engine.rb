require "action_view/log_subscriber"
require_relative "rails/middleware"
require_relative "models/collection"
require_relative "instrument/metrics_collector"
require_relative "extensions/resources_monitor"

module RailsPerformance
  class Engine < ::Rails::Engine
    isolate_namespace RailsPerformance

    # Run migrations for the performance tracking tables
    initializer "rails_performance.create_database" do
      ActiveSupport.on_load(:active_record) do
        begin
          # Try to run pending migrations for rails_performance
          migration_context = ActiveRecord::MigrationContext.new(
            File.join(RailsPerformance::Engine.root, "db", "migrate"),
            ActiveRecord::SchemaMigration
          )
          
          if migration_context.needs_migration?
            migration_context.migrate
          end
        rescue => e
          Rails.logger.warn "RailsPerformance: Could not run database migrations: #{e.message}"
        end
      end
    end

    # Run cleanup periodically to remove old records
    initializer "rails_performance.cleanup" do
      ActiveSupport.on_load(:active_record) do
        # Schedule cleanup to run periodically
        if defined?(Rails::Server)
          Thread.new do
            loop do
              sleep(3600) # Run every hour
              begin
                RailsPerformance::Models::RequestRecord.cleanup_old_records
                RailsPerformance::Models::SidekiqRecord.cleanup_old_records
                RailsPerformance::Models::GrapeRecord.cleanup_old_records
                RailsPerformance::Models::RakeRecord.cleanup_old_records
                RailsPerformance::Models::DelayedJobRecord.cleanup_old_records
                RailsPerformance::Models::CustomRecord.cleanup_old_records
                # Resource records use a different duration
                cutoff_time = RailsPerformance.system_monitor_duration.ago
                RailsPerformance::Models::ResourceRecord.where('created_at < ?', cutoff_time).delete_all
                # Trace records use recent_requests_time_window
                cutoff_time = RailsPerformance.recent_requests_time_window.ago
                RailsPerformance::Models::TraceRecord.where('created_at < ?', cutoff_time).delete_all
              rescue => e
                Rails.logger.warn "RailsPerformance cleanup error: #{e.message}"
              end
            end
          end
        end
      end
    end

    initializer "rails_performance.resource_monitor" do
      # check required gems are available
      RailsPerformance._resource_monitor_enabled = !!(defined?(Sys::Filesystem) && defined?(Sys::CPU) && defined?(GetProcessMem))

      next unless RailsPerformance.enabled
      next if $rails_performance_running_mode == :console # rubocop:disable Style/GlobalVars

      # start monitoring
      RailsPerformance._resource_monitor = RailsPerformance::Extensions::ResourceMonitor.new(
        ENV["RAILS_PERFORMANCE_SERVER_CONTEXT"].presence || "rails",
        ENV["RAILS_PERFORMANCE_SERVER_ROLE"].presence || "web"
      )
    end

    initializer "rails_performance.middleware" do |app|
      next unless RailsPerformance.enabled

      app.middleware.insert_after ActionDispatch::Executor, RailsPerformance::Rails::Middleware
      # look like it works in reverse order?
      app.middleware.insert_before RailsPerformance::Rails::Middleware, RailsPerformance::Rails::MiddlewareTraceStorerAndCleanup

      if defined?(::Sidekiq)
        require_relative "gems/sidekiq_ext"

        Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.add RailsPerformance::Gems::SidekiqExt
          end

          config.on(:startup) do
            if $rails_performance_running_mode != :console # rubocop:disable Style/GlobalVars
              # stop web monitoring
              # when we run sidekiq it also starts web monitoring (see above)
              RailsPerformance._resource_monitor.stop_monitoring
              RailsPerformance._resource_monitor = nil
              # start background monitoring
              RailsPerformance._resource_monitor = RailsPerformance::Extensions::ResourceMonitor.new(
                ENV["RAILS_PERFORMANCE_SERVER_CONTEXT"].presence || "sidekiq",
                ENV["RAILS_PERFORMANCE_SERVER_ROLE"].presence || "background"
              )
            end
          end
        end
      end

      if defined?(::Grape)
        require_relative "gems/grape_ext"
        RailsPerformance::Gems::GrapeExt.init
      end

      if defined?(::Delayed::Job)
        require_relative "gems/delayed_job_ext"
        RailsPerformance::Gems::DelayedJobExt.init
      end
    end

    initializer :configure_metrics, after: :initialize_logger do
      next unless RailsPerformance.enabled

      ActiveSupport::Notifications.subscribe(
        "process_action.action_controller",
        RailsPerformance::Instrument::MetricsCollector.new
      )
    end

    config.after_initialize do
      next unless RailsPerformance.enabled

      ActionView::LogSubscriber.send :prepend, RailsPerformance::Extensions::View
      ActiveRecord::LogSubscriber.send :prepend, RailsPerformance::Extensions::Db if defined?(ActiveRecord)

      if defined?(::Rake::Task) && RailsPerformance.include_rake_tasks
        require_relative "gems/rake_ext"
        RailsPerformance::Gems::RakeExt.init
      end
    end

    if defined?(::Rails::Console)
      $rails_performance_running_mode = :console # rubocop:disable Style/GlobalVars
    end
  end
end
