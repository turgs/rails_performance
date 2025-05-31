module RailsPerformance
  module Reports
    class TraceReport
      attr_reader :request_id

      def initialize(request_id:)
        @request_id = request_id
      end

      def data
        trace_record = RailsPerformance::Models::TraceRecord.find_by(request_id: request_id)
        return [] unless trace_record

        JSON.parse(trace_record.data.presence || "[]")
      rescue JSON::ParserError
        []
      end
    end
  end
end
