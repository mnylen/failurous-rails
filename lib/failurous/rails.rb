require 'failurous'

module Failurous::Rails
  ROOT = File.dirname(__FILE__)
  
  autoload :Config,           "#{ROOT}/rails/config"
  autoload :FailNotification, "#{ROOT}/rails/fail_notification"
end