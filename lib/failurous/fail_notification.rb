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
    
    def title(title)
      @notification_data[:title] = title
    end
    
    def location(location)
      @notification_data[:location] = location
    end
    
    def use_title_in_checksum(value = false)
      defaults[:use_title_in_checksum] = value
    end
    
    def use_location_in_checksum(value = true)
      defaults[:use_location_in_checksum] = value
    end
    
    def section(name, &block)
      section = @notification_data[:sections][name] || Section.new(name)
      @notification_data[:sections][name] = section
      
      if block_given?
        block.call(section)
      end
      
      section
    end
    
    def convert_to_failurous_internal_format
      {
        :title => @notification_data[:title],
        :location => @notification_data[:location],
        :use_title_in_checksum => @notification_data[:use_title_in_checksum],
        :use_location_in_checksum => @notification_data[:use_location_in_checksum],
        :data => [].tap { |data| @notification_data[:sections].values.each { |section| data << section.convert_to_failurous_internal_format } }
      }
    end
    
  end
  
  class Section
    def initialize(name)
      @fields = Dictionary.new
      @name = name
    end
    
    def field(name, value, options = {})
      field = Field.new(name, value, options.dup)
      
      if options[:after] or options[:before]
        @fields.delete(name) if @fields.has_key?(name)
        
        i = 0
        search = options[:before] || options[:after]
        @fields.order.each do |key|
          break if key == search
          i += 1
        end
        
        i ||= @fields.size
        @fields.insert(i, name, field) if options[:before]
        @fields.insert(i+1, name, field) if options[:after]
      else
        @fields[name] = field
      end
      
      field
    end
    
    def convert_to_failurous_internal_format
      data = [@name, []]
      fields.each do |field|
        data[1] << field.convert_to_failurous_internal_format
      end
      
      data
    end
    
    def fields
      @fields.values
    end
  end
  
  class Field
    attr_accessor :name, :value, :options
    
    def initialize(*args)
      @name, @value, @options = args
      filter_options!
    end
    
    def filter_options!
      @options.delete(:before)
      @options.delete(:after)
    end
    
    def convert_to_failurous_internal_format
      [name, value, options]
    end
  end
end