module RailsPerformance
  module Models
    class ResourceRecord < Base
      self.table_name = 'rails_performance_resource_records'

      validates :server, :context, :role, :datetime, :datetimei, presence: true

      scope :by_server, ->(server) { where(server: server) if server.present? }
      scope :by_context, ->(context) { where(context: context) if context.present? }
      scope :by_role, ->(role) { where(role: role) if role.present? }
      scope :by_date, ->(date) { where("datetime LIKE ?", "#{date.strftime('%Y%m%d')}%") if date.present? }

      def record_hash
        parsed_data = parsed_json_data
        {
          server: server,
          role: role,
          context: context,
          datetime: datetime,
          datetimei: RailsPerformance::Utils.from_datetimei(datetimei.to_i),
          cpu: parsed_data["cpu"],
          memory: parsed_data["memory"],
          disk: parsed_data["disk"]
        }
      end

      private

      def parsed_json_data
        @parsed_json_data ||= begin
          JSON.parse(data.to_s)
        rescue
          {}
        end
      end
    end
  end
end
