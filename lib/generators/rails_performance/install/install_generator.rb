class RailsPerformance::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  desc "Generates initial config for rails_performance gem"

  def copy_initializer_file
    copy_file "initializer.rb", "config/initializers/rails_performance.rb"
  end

  def show_setup_instructions
    say "\n" + "="*60
    say "Rails Performance gem setup completed!"
    say "="*60
    say "\nThe gem will automatically:"
    say "• Create its own SQLite database at storage/rails_performance.sqlite3"
    say "• Run migrations automatically on Rails startup"
    say "• Store all performance data in the separate database"
    say "\nNo additional migration commands needed!"
    say "\nThe performance dashboard will be available at:"
    say "http://localhost:3000/rails/performance"
    say "\nYou can customize the database path in the initializer:"
    say "config/initializers/rails_performance.rb"
    say "="*60
  end
end
