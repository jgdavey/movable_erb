require 'rubygems'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "movable_erb"
    gemspec.summary = "A General-purpose CSV to ERB template formatter"
    gemspec.description = "A General-purpose CSV to ERB template formatter. Useful for converting legacy CSV data to an importable blog format."
    gemspec.email = "josh@joshuadavey.com"
    gemspec.homepage = "http://github.com/jgdavey/movable_erb"
    gemspec.authors = ["Joshua Davey"]
    gemspec.add_dependency('fastercsv', '>= 1.5.0')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end


Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

