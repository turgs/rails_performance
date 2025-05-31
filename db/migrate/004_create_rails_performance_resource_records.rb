class CreateRailsPerformanceResourceRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_resource_records do |t|
      t.string :server, null: false
      t.string :context, null: false
      t.string :role, null: false
      t.string :datetime, null: false
      t.bigint :datetimei, null: false
      t.text :data # JSON data (cpu, memory, disk)
      
      t.timestamps

      t.index [:server]
      t.index [:context]
      t.index [:role]
      t.index [:datetimei]
      t.index [:datetime]
    end
  end
end