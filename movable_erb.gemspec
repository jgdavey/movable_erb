# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{movable_erb}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Davey"]
  s.date = %q{2010-02-01}
  s.default_executable = %q{movable_erb}
  s.description = %q{A General-purpose CSV to ERB template formatter. Useful for converting legacy CSV data to an importable blog format.}
  s.email = %q{josh@joshuadavey.com}
  s.executables = ["movable_erb"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gems",
     ".gitignore",
     "CHANGELOG",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/movable_erb",
     "config.ru",
     "cucumber.yml",
     "features/csv.feature",
     "features/step_definitions/csv_steps.rb",
     "features/step_definitions/tmp.csv",
     "features/support/env.rb",
     "lib/app.rb",
     "lib/movable_erb.rb",
     "lib/templates/mtimport.erb",
     "lib/trollop.rb",
     "movable_erb.gemspec",
     "public/blueprint.css",
     "public/custom.css",
     "spec/csv_spec.rb",
     "spec/fixtures/advanced.csv",
     "spec/fixtures/example.csv",
     "spec/fixtures/template.erb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "tasks/rspec.rake",
     "views/index.erb",
     "views/layout.erb"
  ]
  s.homepage = %q{http://github.com/jgdavey/movable_erb}
  s.rdoc_options = ["--charset=UTF-8", "--exclude=trollop"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A General-purpose CSV to ERB template formatter}
  s.test_files = [
    "spec/csv_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fastercsv>, [">= 1.5.0"])
    else
      s.add_dependency(%q<fastercsv>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<fastercsv>, [">= 1.5.0"])
  end
end

