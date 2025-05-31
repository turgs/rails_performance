module RailsPerformance
  module Models
    class DelayedJobRecord < Base
      self.table_name = 'rails_performance_delayed_job_records'

      validates :jid, :datetime, :datetimei, presence: true
      validates :jid, uniqueness: true

      scope :by_status, ->(status) { where(status: status) if status.present? }
      scope :by_class_name, ->(class_name) { where(class_name: class_name) if class_name.present? }
      scope :by_date, ->(date) { where("datetime LIKE ?", "#{date.strftime('%Y%m%d')}%") if date.present? }

      def record_hash
        {
          jid: jid,
          datetime: RailsPerformance::Utils.from_datetimei(datetimei),
          datetimei: datetimei,
          duration: duration,
          status: status,
          source_type: source_type,
          class_name: class_name,
          method_name: method_name
        }
      end
    end
  end
end
