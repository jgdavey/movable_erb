require 'spec/rake/spectask'

namespace :spec do
  desc "Run all examples with RCov"
  Spec::Rake::SpecTask.new('rcov') do |t|
    t.spec_files = FileList['spec']
    t.spec_opts << ["--color"]
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec/,tasks/,coverage/,features/,/System/,/Library/,lib/trollop.rb']
  end
end