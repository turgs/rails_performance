module RailsPerformance
  module Models
    class TraceRecord < Base
      self.table_name = 'rails_performance_trace_records'

      validates :request_id, presence: true
      validates :request_id, uniqueness: true

      def save!(**args)
        return false if data.blank?
        self.data = data.to_json if data.is_a?(Array) || data.is_a?(Hash)
        super
      end

      def save(**args) 
        return false if data.blank?
        self.data = data.to_json if data.is_a?(Array) || data.is_a?(Hash)
        super
      end
    end
  end
end
