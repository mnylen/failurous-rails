require 'rubygems'
require 'bundler'
Bundler.setup

require 'failurous'
require File.join(File.dirname(__FILE__), '..', 'lib', 'failurous', 'rails')

require 'rack/test'
require File.join(File.dirname(__FILE__), 'support', 'rails_app', 'config/environment')

require 'rspec'
RSpec.configure do |config|
  config.mock_with :rspec
end
