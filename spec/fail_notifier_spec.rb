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
  end
  
  it "should post to the given server" do
    http = mock()
    Net::HTTP.should_receive(:new).with('localhost', 5000).and_return(http)
    
    http.should_receive(:post).with('/api/projects/asdf/fails', anything())
    Failurous::FailNotifier.send_fail(@notification)
  end
  
  it "should not fail when Net::HTTP#post raises error" do
    http = mock()
    http.should_receive(:post).and_raise(SocketError)
    Net::HTTP.should_receive(:new).and_return(http)
    
    lambda {
      Failurous::FailNotifier.send_fail(@notification)
    }.should_not raise_exception
  end
end