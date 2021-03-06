# @author Joshua Davey
class MovableErb
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp
  attr_accessor :csv, :erb, :separator

  DEFAULT_TEMPLATE = File.expand_path(File.dirname(__FILE__) + '/templates/mtimport.erb')

  ##
  # @param [Hash] options
  # @option options [String] :template ("mtimport.erb") Path to the ERB template file to use
  # @option options [String] :csv <b>Required.</b> Path to the CSV file to convert
  # @option options [String] :separator ("") Defaults to empty String, ""
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

  ##
  # Converts each row of the CSV file and collects it into @results
  # @return [String] parsed results joined by the separator
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

##
# Loads a CSV document into an array of hashes
class MovableErb::CSV
  if RUBY_VERSION =~ /1.9/
    require 'csv'
    CSV_PARSER = ::CSV
  else
    require 'fastercsv'
    CSV_PARSER = FasterCSV
  end

  attr_accessor :filename, :hashes
  attr_reader :headers

  ##
  # Initializes and yields a new instance
  # @yield [csv] a new instance of {MovableErb::CSV}
  # @return [MovableErb::CSV]
  def self.setup(&block)
    raise "no block given" unless block_given?
    csv = self.new
    yield csv
    csv.parse!
  end

  ##
  # Internally calls {#to_hashes}, but returns self
  # @see to_hashes
  # @return [MovableErb::CSV] self
  def parse!
    @hashes = self.to_hashes
    self
  end

  ##
  # Reads the CSV file into an array of hashes
  # @return [Array] an Array of Hashes
  def to_hashes
    raw_arrays = CSV_PARSER.read(filename)
    extract_headers!(raw_arrays)
    raw_arrays.map {|row| to_hash(row) }
  end

  protected

  def extract_headers!(array)
    first_row = array.shift
    first_row.each { |h| h && h.downcase! && h.gsub!(/\s/,"_") } if first_row
    @headers = first_row
  end

  def to_hash(cells)
    hash = Hash.new
    headers.each_with_index do |column_name, column_index|
      next unless cells[column_index]
      hash[column_name] ||= []
      hash[column_name] << cells[column_index]
    end
    hash
  end
end

##
# Convenience class to setup and parse data with an ERB template.
class MovableErb::Erb
  require 'erb'

  attr_accessor :template, :parsed_string, :data

  ##
  # Creates a new instance and allow manipulation of it via block.
  #
  # This can be used to initialize and parse quickly.
  #
  # @yield [erb] a new instance of {MovableErb::Erb}
  #
  # @example Create a new instance, setup and build the template
  #   @erb = MovableErb::Erb.setup do |erb|
  #     erb.data = {'hash' => 'of', 'meaningful' => 'values'}
  #     erb.template = "path/to/template.erb"
  #     erb.build!
  #   end
  # @return [MovableErb::Erb]
  def self.setup
    raise "no block given" unless block_given?
    erb = self.new
    yield erb
    erb
  end

  ##
  # Sets the template file to use and reads it into a string
  #
  # Note: this is required before {#build!} can be called.
  # @return [String] the unparsed template
  def template=(template_file)
    @template = File.read template_file
  end

  ##
  # Using the specified template, this will parse the template
  # @return [String] the parsed template
  def build!
    erb = ERB.new(template, nil, '<>')
    @parsed_string = erb.result(binding) if erb
  end
end
