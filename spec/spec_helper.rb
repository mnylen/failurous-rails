require 'rubygems'
require 'bundler'
Bundler.setup

require 'failurous'
require File.join(File.dirname(__FILE__), '..', 'lib', 'failurous', 'rails')

require 'rspec'
RSpec.configure do |config|
  config.mock_with :rspec
end