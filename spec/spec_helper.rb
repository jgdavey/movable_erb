require 'rubygems'

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib movable_erb]))

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
