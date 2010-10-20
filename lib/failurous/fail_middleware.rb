# Based on exception_notification
#    http://github.com/rails/exception_notification
#    Copyright (c) 2005 Jamis Buck, released under the MIT license

require 'action_dispatch'

module Failurous
  class FailMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      unless Config.ignore_exceptions.include?(exception.class)
        send_exception_notification(env, exception)
      end

      raise exception
    end
  
    private
  
    def send_exception_notification(env, exception)
      @env        = env
      @exception  = exception
      @controller = env['action_controller.instance'] || MissingController.new
      @request    = ActionDispatch::Request.new(env)

      FailNotification.send(exception) do |notification|
        notification.location "#{@controller.controller_name}##{@controller.action_name}"
        
        notification.section(:request) do |request|
          request.field(:REQUEST_METHOD, @request.method, {:humanize_field_name => false})
          request.field(:REQUEST_URI, @request.request_uri, {:humanize_field_name => false})
          request.field(:REMOTE_ADDR, @request.remote_ip, {:humanize_field_name => false})
          request.field(:HTTP_USER_AGENT, @request.headers["User-Agent"], {:humanize_field_name => false})
        end
        
        notification.section(:summary) do |summary|
          summary.field(:params, @controller.params, {:use_in_checksum => false})
        end
      end
    end
  end
end