module RailsPerformance
  module Models
    class Base < ActiveRecord::Base
      self.abstract_class = true
      
      def duration
        self[:duration]
      end

      private

      def ms(e)
        e.to_f.round(1).to_s + " ms" if e
      end
    end
  end
end