class RailsPerformance::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  desc "Generates initial config for rails_performance gem"

  def copy_initializer_file
    copy_file "initializer.rb", "config/initializers/rails_performance.rb"
  end

  def copy_migrations
    # Get the path to the gem's migrations
    gem_migrations_path = File.expand_path("../../../../db/migrate", __dir__)
    
    Dir.glob(File.join(gem_migrations_path, "*.rb")).each do |migration_file|
      filename = File.basename(migration_file)
      # Generate timestamp
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      # Extract the migration name without number prefix
      migration_name = filename.gsub(/^\d+_/, '')
      timestamped_filename = "#{timestamp}_#{migration_name}"
      
      copy_file File.join("../../../../db/migrate", filename), "db/migrate/#{timestamped_filename}"
      
      # Increment timestamp to avoid conflicts
      sleep(1)
    end
  end
end
