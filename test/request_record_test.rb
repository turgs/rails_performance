require "test_helper"

class RequestRecordTest < ActiveSupport::TestCase
  test "storing" do
    assert_nothing_raised do
      record = dummy_event
      record.save
    end
  end

  test "record creation and retrieval" do
    record = RailsPerformance::Models::RequestRecord.create!(
      controller: "HomeController",
      action: "index",
      format: "html",
      status: 200,
      datetime: "20200124T0531",
      datetimei: 1579861868,
      method: "GET",
      path: "/",
      request_id: "1fb7f6c4d874e10644e1259ac44b514e",
      duration: 27.329741000000002,
      exception: "ZeroDivisionError divided by 0",
      backtrace: [
        "/root/projects/rails_performance/test/dummy/app/controllers/account/site_controller.rb:17:in `/'",
        "/root/projects/rails_performance/test/dummy/app/controllers/account/site_controller.rb:17:in `crash'",
        "/usr/local/rvm/gems/ruby-2.6.3/gems/actionpack-6.1.3.1/lib/action_controller/metal/basic_implicit_render.rb:6:in `send_action'"
      ]
    )

    assert_equal record.controller, "HomeController"
    assert_equal record.status, 200
    assert_equal record.duration, 27.329741000000002
    assert_equal record.exception, "ZeroDivisionError divided by 0"
    assert_equal record.parsed_backtrace.class, Array
    assert_equal record.parsed_backtrace.size, 3
    assert_equal record.request_id, "1fb7f6c4d874e10644e1259ac44b514e"

    # Test finding by request_id
    found_record = RailsPerformance::Models::RequestRecord.find_by(request_id: record.request_id)
    assert_not_nil found_record
    assert_equal found_record.controller, "HomeController"
  end
end
