class CreateRailsPerformanceRequestRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_request_records do |t|
      t.string :controller, null: false
      t.string :action, null: false
      t.string :format, null: false
      t.integer :status, null: false
      t.string :datetime, null: false
      t.bigint :datetimei, null: false
      t.string :method, null: false
      t.string :path, null: false
      t.string :request_id, null: false
      
      # Performance metrics stored as JSON in the Redis version
      t.float :view_runtime
      t.float :db_runtime
      t.float :duration
      t.string :http_referer
      t.text :custom_data # JSON
      t.text :exception
      t.text :backtrace # JSON array
      
      t.timestamps

      t.index [:controller, :action]
      t.index [:status]
      t.index [:datetimei]
      t.index [:request_id], unique: true
      t.index [:datetime]
      t.index [:path]
      t.index [:method]
    end
  end
end