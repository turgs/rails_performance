require "test_helper"

class RailsPerformance::BaseTest < ActiveSupport::TestCase
  test "ms method on models" do
    record = RailsPerformance::Models::RequestRecord.new

    assert_equal record.send(:ms, 1), "1.0 ms"
  end
end
