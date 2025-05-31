module RailsPerformance
  module Models
    class RakeRecord < Base
      self.table_name = 'rails_performance_rake_records'

      validates :task, :datetime, :datetimei, presence: true

      scope :by_status, ->(status) { where(status: status) if status.present? }
      scope :by_date, ->(date) { where("datetime LIKE ?", "#{date.strftime('%Y%m%d')}%") if date.present? }

      def record_hash
        {
          task: parsed_task,
          datetime: RailsPerformance::Utils.from_datetimei(datetimei),
          datetimei: datetimei,
          duration: duration,
          status: status
        }
      end

      private

      def parsed_task
        @parsed_task ||= begin
          JSON.parse(task.to_s)
        rescue
          task
        end
      end
    end
  end
end
