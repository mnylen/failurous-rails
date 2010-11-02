module Failurous::Rails
  class Config < Failurous::Config
    # Lists all exceptions that should be ignored, i.e, when these occur in actions, notifications will not be sent
    attr_accessor :ignore_exceptions
    
    def initialize
      self.custom_notification = Failurous::Rails::FailNotification
      self.ignore_exceptions   = []
    end
  end
end