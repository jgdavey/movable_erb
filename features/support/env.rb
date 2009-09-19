require 'rubygems'
require 'spec'

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. .. lib movable_erb]))

require "mocha"
 
World(Mocha::API)
 
Before do
  mocha_setup
end
 
After do
  begin
    mocha_verify
  ensure
    mocha_teardown
  end
end