module RailsPerformance
  module Models
    class CustomRecord < Base
      self.table_name = 'rails_performance_custom_records'

      validates :tag_name, :namespace_name, :datetime, :datetimei, presence: true

      scope :by_tag_name, ->(tag_name) { where(tag_name: tag_name) if tag_name.present? }
      scope :by_namespace_name, ->(namespace_name) { where(namespace_name: namespace_name) if namespace_name.present? }
      scope :by_status, ->(status) { where(status: status) if status.present? }
      scope :by_date, ->(date) { where("datetime LIKE ?", "#{date.strftime('%Y%m%d')}%") if date.present? }

      def record_hash
        {
          tag_name: tag_name,
          namespace_name: namespace_name,
          status: status,
          datetimei: datetimei,
          datetime: RailsPerformance::Utils.from_datetimei(datetimei.to_i),
          duration: duration
        }
      end
    end
  end
end
