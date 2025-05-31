module RailsPerformance
  module Models
    class GrapeRecord < Base
      self.table_name = 'rails_performance_grape_records'

      validates :request_id, :datetime, :datetimei, presence: true
      validates :request_id, uniqueness: true

      scope :by_status, ->(status) { where(status: status) if status.present? }
      scope :by_format, ->(format) { where(format: format) if format.present? }
      scope :by_method, ->(method) { where(method: method) if method.present? }
      scope :by_path, ->(path) { where(path: path) if path.present? }
      scope :by_date, ->(date) { where("datetime LIKE ?", "#{date.strftime('%Y%m%d')}%") if date.present? }

      def record_hash
        {
          format: format,
          status: status,
          method: method,
          path: path,
          datetime: RailsPerformance::Utils.from_datetimei(datetimei.to_i),
          datetimei: datetimei.to_i,
          request_id: request_id,
          "endpoint_render.grape" => endpoint_render_grape,
          "endpoint_run.grape" => endpoint_run_grape,
          "format_response.grape" => format_response_grape
        }
      end
    end
  end
end
