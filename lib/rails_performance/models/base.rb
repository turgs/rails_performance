module RailsPerformance
  module Models
    class Base < ActiveRecord::Base
      self.abstract_class = true
      
      def duration
        self[:duration]
      end

      # Clean up old records based on the configured duration
      def self.cleanup_old_records
        if respond_to?(:where) && column_names.include?('created_at')
          cutoff_time = RailsPerformance.duration.ago
          where('created_at < ?', cutoff_time).delete_all
        end
      end

      private

      def ms(e)
        e.to_f.round(1).to_s + " ms" if e
      end
    end
  end
end