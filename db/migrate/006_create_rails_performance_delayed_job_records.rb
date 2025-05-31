class CreateRailsPerformanceDelayedJobRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_delayed_job_records do |t|
      t.string :jid, null: false
      t.string :datetime, null: false
      t.bigint :datetimei, null: false
      t.string :source_type
      t.string :class_name
      t.string :method_name
      t.string :status
      t.float :duration
      
      t.timestamps

      t.index [:jid], unique: true
      t.index [:status]
      t.index [:datetimei]
      t.index [:datetime]
      t.index [:class_name]
    end
  end
end