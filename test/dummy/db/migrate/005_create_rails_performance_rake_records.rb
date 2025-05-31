class CreateRailsPerformanceRakeRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_rake_records do |t|
      t.text :task, null: false # JSON
      t.string :datetime, null: false
      t.bigint :datetimei, null: false
      t.string :status
      t.float :duration
      
      t.timestamps

      t.index [:status]
      t.index [:datetimei]
      t.index [:datetime]
    end
  end
end