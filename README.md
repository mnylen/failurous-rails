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
by building a `FailNotification` using the following syntax: 

    Failurous::FailNotification.set_title('Title for your fail').
      add_field(:section_name, :field_name, {:use_in_checksum => true | false}).
      add_field(:another, :field, {...})

To send the exception, you can either call `send` on the built `FailNotification` or use
`FailNotifier.send_fail`


The supported options for fields are:

* `:use_in_checksum` - use the value of the field as combining factor when fails are being combined? (default `false`)
* `:humanize_field_name` - when the fail is shown, should the field name be humanized (e.g. "full_name" => "Full name")? (default `true`)

You can also prepopulate the fail notification from details of exception:

    begin
      raise 'hell'
    rescue => boom
      Failurous::FailNotification.from_exception(boom).add_field(...).send
    end
    
## Upcoming features

* Support for Rails 2
* Better syntax for configuration
* Better syntax for creating custom fail notifications
* Way to add custom details to fail notifications
* Better way to initialize it for just production mode
