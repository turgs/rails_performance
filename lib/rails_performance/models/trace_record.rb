module RailsPerformance
  module Models
    class TraceRecord < Base
      self.table_name = 'rails_performance_trace_records'

      validates :request_id, presence: true
      validates :request_id, uniqueness: true

      def save!
        return false if data.blank?
        super
      end
    end
  end
end
