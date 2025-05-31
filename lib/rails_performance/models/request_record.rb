module RailsPerformance
  module Models
    class RequestRecord < Base
      self.table_name = 'rails_performance_request_records'

      validates :controller, :action, :format, :status, :datetime, :datetimei, :method, :path, :request_id, presence: true
      validates :request_id, uniqueness: true

      scope :by_controller, ->(controller) { where(controller: controller) if controller.present? }
      scope :by_action, ->(action) { where(action: action) if action.present? }
      scope :by_format, ->(format) { where(format: format) if format.present? }
      scope :by_status, ->(status) { where(status: status) if status.present? }
      scope :by_method, ->(method) { where(method: method) if method.present? }
      scope :by_path, ->(path) { where(path: path) if path.present? }
      scope :by_date, ->(date) { where("datetime LIKE ?", "#{date.strftime('%Y%m%d')}%") if date.present? }

      def self.find_by_request_id(request_id)
        find_by(request_id: request_id)
      end

      def controller_action
        "#{controller}##{action}"
      end

      def controller_action_format
        "#{controller}##{action}|#{format}"
      end

      # show on UI in the right panel
      def record_hash
        {
          controller: controller,
          action: action,
          format: format,
          status: status,
          method: method,
          path: path,
          request_id: request_id,
          datetime: RailsPerformance::Utils.from_datetimei(datetimei.to_i),
          datetimei: datetimei,
          duration: duration,
          db_runtime: db_runtime,
          view_runtime: view_runtime,
          exception: exception,
          backtrace: parsed_backtrace,
          http_referer: http_referer
        }.tap do |h|
          if parsed_custom_data.is_a?(Hash)
            h.merge!(parsed_custom_data)
          end
        end
      end

      private

      def parsed_custom_data
        @parsed_custom_data ||= begin
          JSON.parse(custom_data.to_s)
        rescue
          nil
        end
      end

      def parsed_backtrace
        @parsed_backtrace ||= begin
          JSON.parse(backtrace.to_s)
        rescue
          nil
        end
      end
    end
  end
end
