module Failurous::Rails
  class FailMiddleware
    def initialize(app)
      @app = app
    end
    
    def call(env)
      @app.call(env)
    rescue Exception => exception
      unless Failurous::FailNotifier.notifier.config.ignore_exceptions.include?(exception.class)
        notify_of_exception(env, exception)
      end
      
      raise exception
    end
    
    private
    
      def notify_of_exception(env, exception)
        controller = env['action_controller.instance'] || MissingController.new
        Failurous.notify(exception, controller)
      end
  end
end