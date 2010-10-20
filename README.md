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

    Failurous::FailNotification.send do |notification|
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

Failurous currently supports at least the following options for fields:

* `:use_in_checksum` - use the field value in checksum
* `:humanize_field_name` - humanize field name when displaying the

To see full list of field options, please consult Failurous documentation.

The builder also supports the following options for field placement:

* `:before` - insert the new field before the specified field
* `:after` - insert the new field after the specified field

If `:before` and `:after` is omitted, the field will be placed after the last field in the section.

To use an exception as a basis for the notification, pass the exception as a parameter to
`build` method. This will prepopulate the notification with title (in format _type: message_),
location (top of backtrace), and sections _summary_ and _details_.

*Summary* will contain:

* `:type` of the exception (used in checksum)
* exception `:message` (not used in checksum)
* `:top_of_backtrace` (used in checksum)

*Details* will contain:

* `:full_backtrace` (not used in checksum)

    
## Upcoming features

* Support for Rails 2
* Better syntax for configuration
* Way to add custom details to fail notifications
* Better way to initialize it for just production mode
