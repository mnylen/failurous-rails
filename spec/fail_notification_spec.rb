require 'spec_helper'

describe Failurous::FailNotification do
  describe "#build" do
    it "should pass the notification to the block" do
      Failurous::FailNotification.build do |notification|
        notification.should be_a(Failurous::FailNotification)
      end
    end
  end
  
  describe "#section" do
    it "should create a new section when called for the first time and pass the section to the block" do
      notification = Failurous::FailNotification.build() do |notification|
        notification.section(:summary) do |summary|
          summary.should be_a(Failurous::Section)
        end
      end
    
      notification.notification_data[:sections].size.should == 1
    end
    
    it "should not create a new section when called for the second time with the same section name" do
      notification = Failurous::FailNotification.build() do |notification|
        notification.section(:summary).should == notification.section(:summary)
        notification.notification_data[:sections].size.should == 1
      end
    end
  end
end