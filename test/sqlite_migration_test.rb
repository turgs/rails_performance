require 'test_helper'

class SqliteMigrationTest < ActiveSupport::TestCase
  def test_models_can_be_created
    # Test RequestRecord
    request_record = RailsPerformance::Models::RequestRecord.new(
      controller: 'TestController',
      action: 'index', 
      format: 'html',
      status: 200,
      datetime: '20240101T1200',
      datetimei: Time.now.to_i,
      method: 'GET',
      path: '/',
      request_id: SecureRandom.hex(16),
      duration: 100.5
    )
    
    assert request_record.valid?, "RequestRecord should be valid"
    assert request_record.save, "RequestRecord should save successfully"
    
    # Test that it can be found
    found_record = RailsPerformance::Models::RequestRecord.find_by(request_id: request_record.request_id)
    assert_not_nil found_record, "Should be able to find saved record"
    assert_equal request_record.controller, found_record.controller
  end
  
  def test_sidekiq_record_creation
    sidekiq_record = RailsPerformance::Models::SidekiqRecord.new(
      queue: 'default',
      worker: 'TestWorker',
      jid: SecureRandom.hex(12),
      datetime: '20240101T1200',
      datetimei: Time.now.to_i,
      duration: 50.0
    )
    
    assert sidekiq_record.valid?, "SidekiqRecord should be valid"
    assert sidekiq_record.save, "SidekiqRecord should save successfully"
  end
  
  def test_trace_record_with_json_data
    trace_record = RailsPerformance::Models::TraceRecord.new(
      request_id: SecureRandom.hex(16),
      data: [{ name: 'test', duration: 10 }]
    )
    
    assert trace_record.save, "TraceRecord should save successfully"
    
    # Verify JSON serialization worked
    found_record = RailsPerformance::Models::TraceRecord.find_by(request_id: trace_record.request_id)
    assert_not_nil found_record
    
    parsed_data = JSON.parse(found_record.data)
    assert_equal 'test', parsed_data[0]['name']
  end
  
  def test_data_source_querying
    # Create some test data
    record = RailsPerformance::Models::RequestRecord.create!(
      controller: 'HomeController',
      action: 'index',
      format: 'html', 
      status: 200,
      datetime: Date.today.strftime('%Y%m%d') + 'T1200',
      datetimei: Time.now.to_i,
      method: 'GET',
      path: '/',
      request_id: SecureRandom.hex(16),
      duration: 123.45
    )
    
    # Test DataSource
    data_source = RailsPerformance::DataSource.new(
      type: :requests,
      q: { controller: 'HomeController', on: Date.today }
    )
    
    collection = data_source.add_to
    assert collection.data.any?, "Should find at least one record"
    
    found_record = collection.data.first
    assert_equal 'HomeController', found_record.controller
    assert_equal 'index', found_record.action
  end
end