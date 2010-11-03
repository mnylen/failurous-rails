require 'jeweler'

task :default => [:spec]

task :spec do
  system "rspec ."
end

Jeweler::Tasks.new do |gem|
  gem.name        = "failurous-rails"
  gem.summary     = "Rails notifier for Failurous"
  gem.description = "failurous-rails is a Rails notifier for sending notifications to Failurous from Ruby on Rails applications"
  gem.homepage    = "http://github.com/mnylen/failurous-rails"
  gem.authors     = ["Mikko Nylén", "Tero Parviainen", "Antti Forsell"]
              
  gem.files.exclude 'Gemfile'
  gem.files.exclude 'Gemfile.lock'
  gem.files.exclude '.rvmrc'
end
