module RailsPerformance
  module Models
    class Collection
      attr_reader :data

      def initialize
        @data = []
      end

      def add(record)
        @data << record
      end

      def group_by(type)
        case type
        when :controller_action, :controller_action_format, :datetime, :path
          fetch_values @data.group_by(&type)
        else
          {}
        end
      end

      def fetch_values(groupped_collection)
        result = {}
        groupped_collection.each do |key, records|
          result[key] ||= []
          records.each do |record|
            # Convert ActiveRecord record to hash for compatibility
            record_data = {
              "duration" => record.duration,
              "view_runtime" => record.respond_to?(:view_runtime) ? record.view_runtime : nil,
              "db_runtime" => record.respond_to?(:db_runtime) ? record.db_runtime : nil
            }
            # Add any other attributes specific to the record type
            if record.respond_to?(:message)
              record_data["message"] = record.message
            end
            result[key] << record_data
          end
        end
        result
      end
    end
  end
end
