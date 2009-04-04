require 'rubygems'
require 'fastercsv'

module MovableErb
  class Csv
    attr_reader :file
    def initialize(args)
      if args[:file]
        @file = args[:file]
      end
    end
    
    def rows
      FasterCSV.read(file)
    end
    
    def header
      rows.first
    end
    
    def data
      rows[1..rows.length]
    end
  end
end