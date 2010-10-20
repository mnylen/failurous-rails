module Failurous
  ROOT_PATH = File.dirname(__FILE__)
  autoload :Config,            "#{ROOT_PATH}/failurous/config"
  autoload :FailNotification,  "#{ROOT_PATH}/failurous/fail_notification"
  autoload :FailNotifier,      "#{ROOT_PATH}/failurous/fail_notifier"
  autoload :FailMiddleware,    "#{ROOT_PATH}/failurous/fail_middleware"
  
  def self.configure(&block)
    block.call(Failurous::Config)
    ::Rails.application.middleware.use FailMiddleware
  end
end