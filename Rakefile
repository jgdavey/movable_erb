require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('movable_erb') do |p|
  p.description    = "A General-purpose CSV to ERB template formatter"
  p.url            = "http://github.com/jgdavey/movable_erb"
  p.author         = "Joshua Davey"
  p.email          = "josh@joshuadavey.com"
  p.ignore_pattern = ["tmp/*", "script/*", "coverage/*"]
  p.development_dependencies = ['rspec']
  p.executable_pattern = ["bin/*"]
  p.runtime_dependencies = ["fastercsv", "trollop"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

