require 'failurous'

module Failurous::Rails
  ROOT = File.dirname(__FILE__)
  
  autoload :Config,           "#{ROOT}/rails/config"
  autoload :FailNotification, "#{ROOT}/rails/fail_notification"
  autoload :FailMiddleware,   "#{ROOT}/rails/fail_middleware"
  
  def self.configure(install_middleware = true)
    config = Config.new
    block.call(config)
    
    FailNotifier.notifier = FailNotifier.new(config)
    
    if install_middleware
      ::Rails.application.midleware.use FailMiddleware
    end
  end
end