require 'net/http'
require 'uri'
require 'active_support'

module Failurous
  class FailNotifier
    def self.send_fail(notification)
      data = ::ActiveSupport::JSON.encode(notification.convert_to_failurous_internal_format)
      
      http = ::Net::HTTP.new(Failurous::Config.server_address, Failurous::Config.server_port)
      http.use_ssl = Failurous::Config.use_ssl?
      http.post("/api/projects/#{Failurous::Config.api_key}/fails", data)
    rescue => boom
      
    end
  end
end