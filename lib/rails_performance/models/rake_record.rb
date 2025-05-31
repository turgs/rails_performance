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

      # Handle JSON serialization for task field
      before_save :serialize_task_field

      private

      def serialize_task_field
        self.task = task.to_json if task.is_a?(Array) || task.is_a?(Hash)
      end

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
