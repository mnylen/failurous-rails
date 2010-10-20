require 'spec_helper'

describe Failurous::FailNotification do
  describe "#build" do
    it "should pass the notification to the block" do
      Failurous::FailNotification.build do |notification|
        notification.should be_a(Failurous::FailNotification)
      end
    end
    
    it "should prepopulate the notification from exception" do
      exception = RuntimeError.new("hell")
      exception.stub!(:backtrace).and_return(["foo", "bar"])
      notification = Failurous::FailNotification.build(exception)
      notification.notification_data[:sections].size.should == 2
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
    
    
    describe "#field" do
      before(:each) do
        Failurous::FailNotification.build do |notification|
          @section = notification.section(:summary)
        end
      end
      
      it "should add a field to the section" do
        notification = Failurous::FailNotification.build() do |notification|
          field = @section.field(:type, "NoMethodError", {:use_in_checksum => true})
          @section.fields.size.should == 1
          @section.fields.first.should == field
        end
      end
      
      it "should not create another field when called with the same field name, but override the value and options in existing one" do
        @section.field(:type, "NoMethodError", {:use_in_checksum => true})
        field = @section.field(:type, "FoobarError", {:use_in_checksum => false})
        
        @section.fields.size.should == 1
        @section.fields.first.value.should == "FoobarError"
      end
      
      it "should place the field right before the given field inside the section if :before => :field_name was given in options" do
        @section.field(:type, "NoMethodError", {:use_in_checksum => true})
        field = @section.field(:xyz, "TestTest", {:before => :type})
        
        @section.fields.first.should == field
      end
      
      it "should place the field right after the given field inside the section if :after => :field_name was given in options" do
        @section.field(:type, "NoMethodError")
        @section.field(:message, "Called `tap' for nil:NilClass")
        field = @section.field(:xyz, "TestTest", {:after => :type})
        
        @section.fields[1].should == field
      end
    end
  end
  
  describe "#convert_to_failurous_internal_format" do
    it "should convert the data to a format used by Failurous" do
      notification = Failurous::FailNotification.build() do |notification|
        notification.title "NoMethodError: Called `tap' for nil:NilClass"
        notification.location "test#hello"
        
        notification.section(:summary) do |summary|
          summary.field(:type, "NoMethodError", {:use_in_checksum => true})
          summary.field(:message, "Called `tap' for nil:NilClass", {:use_in_checksum => false})
        end
        
        notification.section(:details) do |details|
          details.field(:full_backtrace, "x\ny\nz", {:use_in_checksum => false})
          details.field(:foobar, "abc", {:before => :full_backtrace, :use_in_checksum => true})
        end
      end
      
      notification.convert_to_failurous_internal_format.should == {
        :title    => "NoMethodError: Called `tap' for nil:NilClass",
        :location => "test#hello",
        :use_title_in_checksum => false,
        :use_location_in_checksum => true,
        :data => [
          [:summary, [
            [:type, "NoMethodError", {:use_in_checksum => true}],
            [:message, "Called `tap' for nil:NilClass", {:use_in_checksum => false}]
          ]],
          [:details, [
            [:foobar, "abc", {:use_in_checksum => true}],
            [:full_backtrace, "x\ny\nz", {:use_in_checksum => false}]
          ]]
        ]
      }
    end
  end
end