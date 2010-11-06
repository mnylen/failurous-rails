RailsApp::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
end

# Set up integration with Failurous
Failurous::Rails.configure do |config|
  config.server_name = "localhost"
  config.server_port = 3000
  config.api_key     = "ASDF"
end
