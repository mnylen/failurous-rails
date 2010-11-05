require 'spec_helper'

describe Failurous::Rails::FailMiddleware do
  before(:all) do
    Failurous::Rails.configure(false) do |config|
      config.ignore_exceptions << ArgumentError
    end
    
    @app = MockApp.new
    @middleware = Failurous::Rails::FailMiddleware.new(@app)
  end
  
  it "should notify of non-ignored errors using Failurous.notify and raise them to upper levels" do
    error = StandardError.new
    kontroller = mock()
    env = {"action_controller.instance" => kontroller}
    @app.should_receive(:call).once().and_raise(error)
    
    Failurous.should_receive(:notify).with(error, kontroller)
    lambda { @middleware.call(env) }.should raise_error(StandardError)
  end
  
  it "should not notify of ignored errors, but raise them to upper levels" do
    error = ArgumentError.new
    kontroller = mock()
    @app.should_receive(:call).once().and_raise(error)
    
    Failurous.should_not_receive(:notify)
    lambda { @middleware.call({}) }.should raise_error(ArgumentError)
  end
end

class MockApp
  def call(env)
    
  end
end