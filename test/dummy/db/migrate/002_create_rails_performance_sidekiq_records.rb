class CreateRailsPerformanceSidekiqRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_performance_sidekiq_records do |t|
      t.string :queue, null: false
      t.string :worker, null: false
      t.string :jid, null: false
      t.string :datetime, null: false
      t.bigint :datetimei, null: false
      t.bigint :enqueued_ati
      t.bigint :start_timei
      t.string :status
      t.float :duration
      t.text :message
      
      t.timestamps

      t.index [:queue]
      t.index [:worker]
      t.index [:jid], unique: true
      t.index [:status]
      t.index [:datetimei]
      t.index [:datetime]
    end
  end
end