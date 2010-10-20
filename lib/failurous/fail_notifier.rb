require 'net/http'
require 'uri'
require 'active_support'

module Failurous
  class FailNotifier
    def self.send_fail(notification)
      server_address, api_key = [Failurous::Config.server_address, Failurous::Config.api_key]
      post_address = "#{server_address}/api/projects/#{api_key}/fails"
      
      data = ::ActiveSupport::JSON.encode(notification.convert_to_failurous_internal_format)
      ::Net::HTTP.post_form URI.parse(post_address), {:data => data}
    end
  end
end