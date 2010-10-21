module Failurous
  class Config
    @@server_address = ""
    @@server_port = 80
    @@api_key = ""
    @@ignore_exceptions = []
        
    class << self
      def server_address=(val)
        @@server_address = val
      end
    
      def server_address
        @@server_address
      end
    
      def api_key=(val)
        @@api_key = val
      end
    
      def api_key
        @@api_key
      end
      
      def ignore_exceptions=(val)
        @@ignore_exceptions = val
      end
      
      def ignore_exceptions
        @@ignore_exceptions
      end
      
      def server_port=(val)
        @@server_port = val
      end
      
      def server_port
        @@server_port
      end
    end
  end
end