module Failurous::Rails
  class FailNotification < Failurous::FailNotification
    def fill_from_object(object)
      if object.kind_of?(ActionController::Base)
        fill_from_controller(object)
      end
      
      self  
    end
    
    def fill_from_controller(controller)
      self.location = "#{controller.controller_name}##{controller.action_name}"   
      request = controller.request
      
      request_uri = if request.respond_to?(:request_uri)
        request.request_uri
      else
        request.fullpath
      end
      
      self.add_field(:request, :REQUEST_METHOD, request.method, {:humanize_field_name => false}).
        add_field(:request, :REQUEST_URI, request_uri, {:humanize_field_name => false}).
        add_field(:request, :REMOTE_ADDR, request.remote_ip, {:humanize_field_name => false}).
        add_field(:request, :HTTP_USER_AGENT, request.headers["User-Agent"], {:humanize_field_name => false}).
        add_field(:summary, :params, controller.params)
    end
  end
end