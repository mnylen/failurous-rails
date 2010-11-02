require 'spec_helper'

describe Failurous::Rails::FailNotification do
  describe "#fill_from_object" do
    before(:each) do
      @notification = Failurous::Rails::FailNotification.new("My custom notification")
    end
  
    it "shouldn't do nothing when the passed object is not ActionController::Base" do
      lambda {
        @notification.fill_from_object(mock())
      }.should_not change(@notification, :attributes)
    end
  end
end