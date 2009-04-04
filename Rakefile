# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'movable_erb'

task :default => 'spec:run'

PROJ.name = 'movable_erb'
PROJ.authors = 'Joshua Davey'
PROJ.email = 'josh@joshuadavey.com'
PROJ.url = 'http://github.com/jgdavey/movable_erb/'
PROJ.version = MovableErb::VERSION
PROJ.rubyforge.name = 'movable_erb'
PROJ.depend_on = 'fastercsv'
PROJ.gem.dependencies = ['fastercsv']

PROJ.spec.opts << '--color'

# EOF
