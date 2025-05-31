class CreateRailsPerformanceGrapeRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_grape_records do |t|
      t.string :request_id, null: false
      t.string :datetime, null: false
      t.bigint :datetimei, null: false
      t.string :format
      t.string :path
      t.integer :status
      t.string :method
      t.float :endpoint_render_grape
      t.float :endpoint_run_grape
      t.float :format_response_grape
      
      t.timestamps

      t.index [:request_id], unique: true
      t.index [:status]
      t.index [:datetimei]
      t.index [:datetime]
      t.index [:path]
      t.index [:method]
    end
  end
end