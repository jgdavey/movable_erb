class MovableErb
  VERSION = "0.2.0"
  attr_accessor :csv, :erb, :separator

  DEFAULT_TEMPLATE = File.expand_path(File.dirname(__FILE__) + '/templates/mtimport.erb')

  def initialize(options = {})
    @erb = MovableErb::Erb.setup do |erb|
      erb.template = options[:template] || DEFAULT_TEMPLATE
    end
    if options[:csv]
      @csv = MovableErb::CSV.setup do |csv|
        csv.filename = options[:csv]
      end
    end
    @separator = options[:separator] || ""
  end

  def convert
    @results = []
    csv.parse!
    csv.hashes.each do |hash_data|
      erb.data = hash_data
      @results << erb.build!
    end
    @results.join(separator)
  end
end

class MovableErb::CSV
  require 'fastercsv'

  attr_accessor :filename, :hashes

  def setup(&block)
    yield self
    parse! if @filename
    self
  end

  def self.setup
    csv = self.new
    yield csv
    csv.parse!
  end

  def parse!
    @hashes = self.to_hashes
    self
  end

  def to_hashes
    array_of_arrays = FasterCSV.read(filename)
    headers = array_of_arrays.shift
    headers.each { |h| h.downcase! && h.gsub!(/\s/,"_") } if headers
    hashes = Array.new(array_of_arrays.length) { Hash.new }
    array_of_arrays.each_with_index do |row,i|
      headers.each_with_index do |header, j|
        unless row[j].nil?
          hashes[i][header] = [] if hashes[i][header].nil?
          hashes[i][header] << row[j]
        end
      end
    end
    hashes
  end
end

class MovableErb::Erb
  require 'erb'

  attr_accessor :template, :parsed_string, :data

  def self.setup
    erb = self.new
    yield erb
    erb
  end

  def template=(template_file)
    @template = File.read template_file
  end

  def setup
    yield self
  end

  def build!
    erb = ERB.new(template, nil, '<>')
    @parsed_string = erb.result(binding) if erb
  end
end