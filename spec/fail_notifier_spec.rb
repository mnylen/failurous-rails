require 'spec_helper'

describe Failurous::FailNotifier do
  before(:each) do
    @notification = Failurous::FailNotification.build do |notification|
      notification.title "Hello, World!"
      notification.use_title_in_checksum true
    end
    
    Failurous::Config.server_address = 'localhost'
    Failurous::Config.api_key = 'asdf'
    Failurous::Config.server_port = 5000
    
    @http = mock()
    @http.stub!(:use_ssl=)
    
    Net::HTTP.should_receive(:new).with('localhost', 5000).and_return(@http)
  end
  
  it "should post to the given server" do
    @http.should_receive(:post).with('/api/projects/asdf/fails', anything())
    Failurous::FailNotifier.send_fail(@notification)
  end
  
  it "should not use SSL if not configured to do so" do
    @http.should_not_receive(:use_ssl=).with(true)
    @http.should_receive(:post)
    Failurous::FailNotifier.send_fail(@notification)
  end
  
  it "should use SSL if configured to do so" do
    Failurous::Config.use_ssl = true

    @http.should_receive(:use_ssl=).with(true)
    @http.should_receive(:post)
    
    Failurous::FailNotifier.send_fail(@notification)
  end
  
  it "should not fail when Net::HTTP#post raises error" do
    @http.should_receive(:post).and_raise(SocketError)
    
    lambda {
      Failurous::FailNotifier.send_fail(@notification)
    }.should_not raise_exception
  end
end