require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'movable_erb')

@articles = File.join(File.dirname(__FILE__), 'articles.csv')
MovableErb.new(:csv => @articles).convert