module RailsPerformance
  module Database
    def self.database_path
      RailsPerformance.database_path || Rails.root.join("storage", "rails_performance.sqlite3")
    end

    def self.database_config
      {
        adapter: 'sqlite3',
        database: database_path.to_s,
        pool: 5,
        timeout: 5000
      }
    end

    def self.establish_connection
      RailsPerformance::Models::Base.establish_connection(database_config)
    rescue => e
      Rails.logger.warn "RailsPerformance: Failed to establish connection: #{e.message}" if defined?(Rails.logger)
      false
    end

    def self.connected?
      RailsPerformance::Models::Base.connected?
    rescue
      false
    end

    def self.disconnect!
      RailsPerformance::Models::Base.remove_connection if connected?
    end

    def self.create_database_if_not_exists
      path = database_path
      return if File.exist?(path)
      
      # Ensure directory exists
      FileUtils.mkdir_p(File.dirname(path))
      
      # Create empty database by establishing connection
      establish_connection
    end

    def self.run_migrations
      create_database_if_not_exists
      establish_connection
      
      # Get the path to migrations
      migrations_path = File.expand_path("../../db/migrate", __dir__)
      
      # Use ActiveRecord's migration context to run migrations
      migration_context = ActiveRecord::MigrationContext.new(
        migrations_path, 
        RailsPerformance::Models::Base.connection.schema_migration
      )
      
      migration_context.migrate
      true
    rescue => e
      Rails.logger.warn "RailsPerformance: Failed to run migrations: #{e.message}" if defined?(Rails.logger)
      false
    end
  end
end