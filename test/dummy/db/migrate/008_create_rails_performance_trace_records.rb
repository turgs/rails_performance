class CreateRailsPerformanceTraceRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_trace_records do |t|
      t.string :request_id, null: false
      t.text :data # JSON trace data
      
      t.timestamps

      t.index [:request_id], unique: true
    end
  end
end