module RailsPerformance
  module Models
    class SidekiqRecord < Base
      self.table_name = 'rails_performance_sidekiq_records'

      validates :queue, :worker, :jid, :datetime, :datetimei, presence: true
      validates :jid, uniqueness: true

      scope :by_queue, ->(queue) { where(queue: queue) if queue.present? }
      scope :by_worker, ->(worker) { where(worker: worker) if worker.present? }
      scope :by_status, ->(status) { where(status: status) if status.present? }
      scope :by_date, ->(date) { where("datetime LIKE ?", "#{date.strftime('%Y%m%d')}%") if date.present? }

      def record_hash
        {
          worker: worker,
          queue: queue,
          jid: jid,
          status: status,
          datetimei: datetimei,
          datetime: RailsPerformance::Utils.from_datetimei(start_timei.to_i),
          duration: duration,
          message: message
        }
      end
    end
  end
end
