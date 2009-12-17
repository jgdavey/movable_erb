require 'rubygems'

if RUBY_VERSION =~ /1.9/
  require 'csv'
  $csv_library = ::CSV
else
  require 'fastercsv'
  $csv_library = FasterCSV
end

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib movable_erb]))

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
