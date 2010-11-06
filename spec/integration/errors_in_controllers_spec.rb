require 'spec_helper'

describe "errors in controllers" do
  include Rack::Test::Methods
  
  def app
    @app ||= Rails.application
  end
end
