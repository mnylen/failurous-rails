# failurous-rails

failurous-rails is a Rails client library used for sending fail notifications to
Failurous (see http://github.com/mnylen/failurous).

## Basic usage

### Rails 3

1\. Add this to your gemfile

    gem 'failurous-rails', :git => 'git://github.com/mnylen/failurous-rails.git'

2\. Next you need to add the following under config/initializer/failurous.rb:
    
    require 'failurous'

    Failurous::Config.server_address = '<full URL to your failurous installation, including the port, e.g "http://localhost:3000">'
    Failurous::Config.api_key = '<api key for your project>'

    Rails.application.config.middleware.use Failurous::FailMiddleware
    
You can find your project's API key by clicking "Project Settings" from Failurous under the desired project page.

3\. `raise 'hell'` from some controller to test things out

### Rails 2

Rails 2 support is upcoming.


## Sending custom notifications to Failurous

failurous-rails can be used to send custom notifications to Failurous. This can be accomplished
by building a `FailNotification`:

    FailNotification.build do |notification|
      notification.title "Title to show in Failurous"
      notification.location "something indicating the location"
      notification.use_title_in_checksum false
      notification.use_location_in_checksum true
  
      notification.section(:summary) do |summary|
        summary.field(:type, "NoMethodError", {:use_in_checksum => true})
        summary.field(:message, "Called `tap' for nil:NilClass", {:use_in_checksum => true})
      end

      notification.section(:request) do |request|
        request.field(:HTTP_USER_AGENT, "Mozilla ...", {:humanize_field_name => false})
      end
    end
    

You can add as many sections and fields as you want.

The supported options in Failurous for fields are:

* `:use_in_checksum` - use the value of the field as combining factor when fails are being combined? (default `false`)
* `:humanize_field_name` - when the fail is shown, should the field name be humanized (e.g. "full_name" => "Full name")? (default `true`)

The builder also allows the following options to be passed:

* `:after` - if given, adds the field *after* the specified field
* `:before` - if given, adds the field *before* the specified field

To use an exception as a basis for the notification, pass the exception as a parameter to
`build` method. This will prepopulate the notification with title (_type: message_)
and sections _summary_ and _details_.

Summary will contain
* `:type` of the exception (used in checksum)
* exception `:message` (not used in checksum)

You can add more sections and fields in the block.

    FailNotification.build(exception) do |notification|
      notification.section(:your_app_name) { |my_app| my_app.field(:username, "...") }
    end

To send the notification after it is built, use the `.send` method (also allows for
optional exception):

    FailNotification.send(exception) do |notification|
      ...
    end                                        
                                                                                          
    
## Upcoming features

* Support for Rails 2
* Better syntax for configuration
* Better syntax for creating custom fail notifications
* Way to add custom details to fail notifications
* Better way to initialize it for just production mode
