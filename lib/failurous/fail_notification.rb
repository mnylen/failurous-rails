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
    
    
    # Creates a new FailNotification instance and passes it to the block. Optionally
    # takes a exception instance which can be used to prepopulate the notification
    # with the following sections and fields:
    #
    # * *:summary* - Summary
    #   * *:type* - Type of exception (e.g. NoMethodError) (used in checksum)
    #   * *:message* - Exception message (not used in checksum)
    #   * *:top_of_backtrace* - The topmost frame in backtrace (used in checksum)
    # 
    # * *:details* - Details
    #   * *:full_backtrace* - Full backtrace (not used in checksum)
    #
    # The title for the notification will be *type:* *message* (not used in checksum) and the location
    # will be the topmost frame in backtrace (used in checksum)
    def self.build(exception = nil, &block)
      notification = FailNotification.new
      notification.prepopulate_from_exception(exception) if exception
      
      if block_given?
        block.call(notification)
      end
      
      notification
    end
    
    
    # Sets the title for the fail notification
    def title(title)
      @notification_data[:title] = title
    end
    
    # Sets the location for the fail notification
    def location(location)
      @notification_data[:location] = location
    end
    
    
    # Sets the boolean flag for using title in the checksum on Failurous
    def use_title_in_checksum(value = false)
      defaults[:use_title_in_checksum] = value
    end
    
    # Sets the boolean flag for using location in the checksum on Failurous 
    def use_location_in_checksum(value = true)
      defaults[:use_location_in_checksum] = value
    end
    
    # Creates a new section with the given name (or returns existing one)
    def section(name, &block)
      section = @notification_data[:sections][name] || Section.new(name)
      @notification_data[:sections][name] = section
      
      if block_given?
        block.call(section)
      end
      
      section
    end
    
    # Converts the notification to internal format used by Failurous,
    # so it can be easily encoded as JSON and sent
    def convert_to_failurous_internal_format
      {
        :title => @notification_data[:title],
        :location => @notification_data[:location],
        :use_title_in_checksum => @notification_data[:use_title_in_checksum],
        :use_location_in_checksum => @notification_data[:use_location_in_checksum],
        :data => [].tap { |data| @notification_data[:sections].values.each { |section| data << section.convert_to_failurous_internal_format } }
      }
    end
    
    
    def prepopulate_from_exception(exception)
      self.title "#{exception.class.to_s}: #{exception.message}"
      self.location "#{exception.backtrace[0]}"

      self.section(:summary) do |summary|
        summary.field(:type, exception.class.to_s, {:use_in_checksum => true})
        summary.field(:message, exception.message, {:use_in_checksum => false})
        summary.field(:top_of_backtrace, exception.backtrace[0], {:use_in_checksum => true})
      end

      self.section(:details) do |details|
        details.field(:full_backtrace, exception.backtrace.join('\n'), {:use_in_checksum => false})
      end
    end
    
  end
  
  # Represents a section inside {FailNotification}.
  #
  # Sections are created using the {FailNotification#section} method - you should
  # not directly create sections using {.new}
  class Section
    def initialize(name)
      @fields = Dictionary.new
      @name = name
    end
    
    
    # Creates a new field to the section. If the field is already in the section,
    # it will be replaced with the new one.
    #
    # Failurous currently supports at least the following options:
    # * *:use_in_checksum* - use the field value in checksum
    # * *:humanize_field_name* - humanize field name when displaying the 
    # To see full list of field options, please consult Failurous documentation.
    # 
    # The builder also supports the following options for field placement:
    # * *:before* - insert the new field before the specified field 
    # * *:after*  - insert the new field after the specified field
    #
    # If *:before* and *:after* is omitted, the field will be placed after the last
    # field in the section.
    # 
    # @param name     name of the field
    # @param value    field value
    # @param options  any options
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
    
    # Converts the section to internal format used by Failurous, 
    # so it can be easily encoded as JSON and sent
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