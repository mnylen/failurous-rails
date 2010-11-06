require 'spec_helper'

describe "configuration" do
  it "should install the middleware" do
    found = false
    Rails.application.middleware.each do |mw|
      if mw == Failurous::Rails::FailMiddleware
        found = true
        break
      end
    end

    found.should == true
  end
end
