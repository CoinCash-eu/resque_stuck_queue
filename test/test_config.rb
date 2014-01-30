require File.join(File.expand_path(File.dirname(__FILE__)), "test_helper")

class TestConfig < Minitest::Test

  include TestHelper

  def setup
    Resque::StuckQueue.config[:trigger_timeout] = 1
    Resque::StuckQueue.config[:heartbeat] = 1
    Resque::StuckQueue.config[:abort_on_exception] = true
    Resque::StuckQueue.config[:redis] = Redis.new
  end

  def teardown
    Resque::StuckQueue.reset!
  end

  def test_config_has_descriptions
    c = Resque::StuckQueue::Config.new
    assert c.description_for(:logger) =~ /Logger/, "has descriptions"
  end

  def test_outputs_all_config_options
    c = Resque::StuckQueue::Config.new
    puts c.pretty_descriptions
    assert true
  end

  def test_has_logger
    puts "#{__method__}"
    begin
      Resque::StuckQueue.config[:logger] = Logger.new($stdout)
      start_and_stop_loops_after(1)
      assert true, "should not have raised"
    rescue => e
      assert false, "should have succeeded with good logger: #{e.inspect}\n#{e.backtrace.join("\n")}"
    end
  end

  def test_must_set_redis
    puts "#{__method__}"
    Resque::StuckQueue.config[:redis] = nil
    begin
      start_and_stop_loops_after(1)
      assert false, "redis cannot be nil"
    rescue Resque::StuckQueue::Config::NoConfigError => e
      assert true, "redis cannot be nil: #{e.inspect}\n#{e.backtrace.join("\n")}"
    end
  end

end


