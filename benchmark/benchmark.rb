require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'movable_erb')
require 'benchmark'

@articles = File.join(File.dirname(__FILE__), 'articles.csv')
@journals = File.join(File.dirname(__FILE__), 'journals.csv')

Benchmark.bmbm do |x|
  x.report("articles") do
    10.times { MovableErb.new(:csv => @articles).convert }
  end
  x.report("journals") do
    10.times { MovableErb.new(:csv => @journals).convert }
  end
end

