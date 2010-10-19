require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

require 'rspec'
RSpec.configure do |config|
  config.mock_with :rspec
end


require 'failurous'