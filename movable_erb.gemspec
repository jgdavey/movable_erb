# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{movable_erb}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Davey"]
  s.date = %q{2009-09-26}
  s.default_executable = %q{movable_erb}
  s.description = %q{A General-purpose CSV to ERB template formatter}
  s.email = %q{josh@joshuadavey.com}
  s.executables = ["movable_erb"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.md", "bin/movable_erb", "lib/movable_erb.rb", "lib/templates/mtimport.erb", "tasks/rspec.rake"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README.md", "Rakefile", "bin/movable_erb", "cucumber.yml", "features/csv.feature", "features/step_definitions/csv_steps.rb", "features/step_definitions/tmp.csv", "features/support/env.rb", "lib/movable_erb.rb", "lib/templates/mtimport.erb", "movable_erb.gemspec", "spec/csv_spec.rb", "spec/fixtures/advanced.csv", "spec/fixtures/example.csv", "spec/fixtures/template.erb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.homepage = %q{http://github.com/jgdavey/movable_erb}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Movable_erb", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{movable_erb}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A General-purpose CSV to ERB template formatter}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fastercsv>, [">= 0"])
      s.add_runtime_dependency(%q<trollop>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<fastercsv>, [">= 0"])
      s.add_dependency(%q<trollop>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<fastercsv>, [">= 0"])
    s.add_dependency(%q<trollop>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
