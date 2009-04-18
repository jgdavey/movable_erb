# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{movable_erb}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Davey"]
  s.date = %q{2009-04-18}
  s.default_executable = %q{movable_erb}
  s.description = %q{}
  s.email = %q{josh@joshuadavey.com}
  s.executables = ["movable_erb"]
  s.extra_rdoc_files = ["History.txt", "bin/movable_erb", "lib/movable_erb/templates/default.erb"]
  s.files = [".gitignore", "History.txt", "README.textile", "Rakefile", "bin/movable_erb", "lib/movable_erb.rb", "lib/movable_erb/csv.rb", "lib/movable_erb/mtimport.rb", "lib/movable_erb/templates/default.erb", "spec/csv_spec.rb", "spec/fixtures/example.csv", "spec/movable_erb_spec.rb", "spec/mtimport_spec.rb", "spec/spec_helper.rb", "test/test_movable_erb.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jgdavey/movable_erb/}
  s.rdoc_options = ["--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{movable_erb}
  s.rubygems_version = %q{1.3.1}
  s.summary = nil
  s.test_files = ["test/test_movable_erb.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fastercsv>, [">= 0"])
      s.add_development_dependency(%q<bones>, [">= 2.5.0"])
    else
      s.add_dependency(%q<fastercsv>, [">= 0"])
      s.add_dependency(%q<bones>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<fastercsv>, [">= 0"])
    s.add_dependency(%q<bones>, [">= 2.5.0"])
  end
end
