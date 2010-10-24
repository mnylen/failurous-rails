module Failurous
  class FailNotification

    # Creates a new FailNotification using the specified title. The notification
    # will be filled with details from the exception and object, if they are given.
    #
    # Location will default to the caller and is used when combining fails.
    #
    # @param title [String] custom title for the notification, if any -- when given, used when combining fails
    # @param exception [Exception] exception that occured, if any
    # @param object [Object] object that caused the fail notification to be built, if applicable
    #
    # @see FailNotification#fill_from_exception
    # @see FailNotification#fill_from_object
    def initialize(title = nil, exception = nil, object = nil)

    end

    # Determines whether FailMiddleware should ignore _exception_ in _object_.
    # Default implementation returns *false* for everything.
    #
    # @param exception [Exception] the exception
    # @param object [Object] the object
    # @return [Boolean] *true* if the exception in object should be ignored; *false* otherwise
    def self.ignore?(exception, object = nil)

    end

    # Fills notification details from the given exception. Please note that
    # if the title and/or location has been specified previously, those
    # are not overriden here.
    #
    # * *Title* will be set to _type:_ _message_. Not used when combining fails. 
    # * *Location* will be set as the topmost frame in backtrace. Used when combining fails.
    #
    # Two sections will be added:
    #
    # Summary
    # * Type (*:type*) of the exception -- used when combining fails 
    # * Exception *message* (*:message*) -- not used when combining fails
    # * Topmost line in backtrace (*:topmost_line_in_backtrace*) -- used when combining fails 
    #
    # Details
    # * Full backtrace (*:full_backtrace*) -- not used when combining fails
    #
    # @param exception [Exception] the exception raised 
    # @return [FailNotification] self
    def fill_from_exception(exception)

    end


    # Fills notification details from the given object. Currently can be used only
    # with derivatives of {ActionController::Base}. Filling details from controllers
    # is delegated to {#fill_from_controller}
    #
    # @param object [Object] the object to fill from
    # @see FailNotification#fill_from_controller
    # @return [FailNotification] self
    def fill_from_object(object)

    end


    # Fills notification details from the given controller. Sets the location to
    # _controller_name_#_action_name_, unless the location has been set by a call to
    # {#location=}. The location will be used when combining fails.
    #
    # The following sections will be added:
    #
    # Details:
    # * Parameters (_:parameters_) - the submitted _params_ - not used when combining fails
    #
    # Request: (none of these is used when combining fails, field names are not humanized)
    #
    # * REQUEST_METHOD
    # * REQUEST_URI
    # * REMOTE_ADDR
    # * HTTP_USER_AGENT
    #
    # @param controller [ActionController::Base] the controller
    # @return [FailNotification] self
    def fill_from_controller(controller)

    end

    
    # Adds a field to the notification. The field will be added to the named section _section_name_ with
    # name _field_name_ and value of _field_value_.
    #
    # If the section does not exists, it will be created. Otherwise the field is added to the section.
    # If the field already exists inside the section, it will be overriden.
    #
    # _field_options_ can contain any options for fields supported by Failurous. At least the following
    # are supported:
    # * _:use_in_checksum_ - *true* if the field should be used when combining fails, defaults to *false*
    # * _:humanize_field_name_ - *true* if the field name should be humanized, defaults to *true*
    # For a full list of supported field options, please see the API documentation for Failurous.
    #
    # Placement of the field inside section can be controller with _placement_. If no placement options
    # are given, the field will be appended to the end of the section. Supported options are:
    # * _:below_ - the field should be placed below the specified field (e.g. *:below* => *:type*)
    # * _:above_ - the field should be placed above the specified field (e.g. *:after* => *:message*)
    # You can use _:first_ and _:last_ to place the field below or above the first or last field in the section.
    # Currently combining _:below_ and _:above_ is not supported.
    #
    # @param section_name [Symbol] name of the section
    # @param field_name [Symbol] name of the section
    # @param field_value [Object] value for the field, will be converted to string using {Object.inspect} if it isn't already a string
    # @param field_options [Hash] options for field
    # @param placement [Hash] placement options
    #
    # @return [FailNotification] self
    def add_field(section_name, field_name, field_value, field_options = {}, placement = {})

    end


    # Moves the named section inside the notification to either below another or
    # above another section.
    #
    # _placement_ can be one of the following:
    # * _:below_ - the section should be moved below another section (e.g. *:below* => *:summary*)
    # * _:above_ - the section should be moved above another section (e.g. *:above* => *:request*)
    #
    # @param section_name [Symbol] the section to move
    # @param placement [Hash] placement option 
    # @return [FailNotification] self
    def move_section(section_name, placement) 

    end

    # Gets the location, or the caller of {#initialize} when the location has not been
    # set by using {#location=}
    #
    # @return location
    def location

    end

    # Sets the location to the specified location. Will override any previous
    # value.
    #
    # @param location [String] the location
    # @see #use_location_in_checksum
    # @see #use_location_in_checksum=
    def location=(location)

    end

    # Gets whether _location_ should be used when combining fails. Defaults to *false*
    #
    # @return [Boolean] *true* if location should be used when combining fails; *false* otherwise
    def use_location_in_checksum

    end

    # Sets whether _location_ should be used when combining fails. 
    #
    # @param value [Boolean] *true* if location should be used when combining fails; *false* otherwise
    def use_location_in_checksum=(value)

    end


    # Gets the title for notification
    #
    # @return title 
    def title 

    end

    # Sets the title to specified title. Will override any previous value.
    #
    # @param title [String] the title 
    # @see #use_title_in_checksum
    # @see #use_title_in_checksum=
    def title=(title)

    end

    # Gets whether _title_ should be used when combining fails. Defaults to *false*
    #
    # @return [Boolean] *true* if title should be used when combining fails; *false* otherwise
    def use_title_in_checksum

    end

    # Sets whether _title_ should be used when combining fails. 
    #
    # @param value [Boolean] *true* if title should be used when combining fails; *false* otherwise
    def use_title_in_checksum=(value)

    end
  end
end
