require 'active_support'
require 'dictionary'

module Failurous
  # Notification of a fail with all the details. Can be sent to the Failurous
  # after building.
  #
  # Usage:
  #
  #    FailNotification.build do |notification|
  #      notification.title "Title to show in Failurous"
  #      notification.location "something indicating the location"
  #      notification.use_title_in_checksum false
  #      notification.use_location_in_checksum true
  #      
  #      notification.section(:summary) do |summary|
  #        summary.field(:type, "NoMethodError", {:use_in_checksum => true})
  #        summary.field(:message, "Called `tap' for nil:NilClass", {:use_in_checksum => true})
  #      end
  #
  #      notification.section(:request) do |request|
  #        request.field(:HTTP_USER_AGENT, "Mozilla ...", {:humanize_field_name => false})
  #      end
  #    end
  #
  # To use an exception as a basis for the notification, pass the exception as a parameter to
  # {.build} method. See the documentation for {.build} for information on the sections and fields
  # added by default. You can add more sections and fields in the block.
  #
  #    FailNotification.build(exception) do |notification|
  #      notification.section(:your_app_name) { |my_app| my_app.field(:username, "...") }
  #    end
  #
  # To send the notification after it is built, use the {.send} method (also allows for
  # optional exception):
  #
  #     FailNotification.send(exception) do |notification|
  #       ...
  #     end
  #
  class FailNotification
    attr_accessor :notification_data
    
    def initialize
      @notification_data = {}.tap do |defaults|
        defaults[:title] = ""
        defaults[:location] = ""
        defaults[:use_title_in_checksum] = false
        defaults[:use_location_in_checksum] = true
        defaults[:sections] = Dictionary.new
      end
    end
    
    def self.build(exception = nil, &block)
      notification = FailNotification.new
      if block_given?
        block.call(notification)
      end
      
      notification
    end
    
    def section(name, &block)
      section = notification_data[:sections][name] || Section.new
      notification_data[:sections][name] = section
      
      if block_given?
        block.call(section)
      end
      
      section
    end
  end
  
  class Section
  end
end