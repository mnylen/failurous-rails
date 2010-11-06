require 'spec_helper'

describe "errors in controllers" do
  include Rack::Test::Methods
  
  def app
    @app ||= Rails.application
  end


  it "should notify of errors in controllers" do
    Failurous.should_receive(:notify)
    get "/troops/move"
  end
end
