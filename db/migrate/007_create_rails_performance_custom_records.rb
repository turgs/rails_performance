class CreateRailsPerformanceCustomRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_custom_records do |t|
      t.string :tag_name, null: false
      t.string :namespace_name, null: false
      t.string :datetime, null: false
      t.bigint :datetimei, null: false
      t.string :status
      t.float :duration
      
      t.timestamps

      t.index [:tag_name]
      t.index [:namespace_name]
      t.index [:status]
      t.index [:datetimei]
      t.index [:datetime]
    end
  end
end