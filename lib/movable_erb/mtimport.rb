module MovableErb
  class MTImport
    require 'erb'
    
    attr_accessor :csv, :template, :body_content
    attr_writer :title_column, :body_column
    
    def initialize(args = {})
      if args[:csv]
        @csv = Csv.new(args[:csv])
      end
        @template = args[:template] || File.join(File.dirname(__FILE__), 'templates', 'default.erb')
    end
    
    def header_rows
      if self.csv
        @csv.header
      else
        raise "No CSV file"
      end
    end
    
    def title_column
      tc = []
      header_rows.each_with_index do |col, i|
        tc << i if col =~ /title/i
      end
      tc.empty? ? [0] : tc
    end

    def body_column
      tc = []
      header_rows.each_with_index do |col, i|
        tc << i if col =~ /body/i
      end
      tc.empty? ? [1] : tc
    end

    def body_content  
      @body_content ||= csv.body.map do |row|
        body_column.map do |i|
          row[i]
        end
      end
    end
    
    def title_content  
      csv.body.map do |row|
        title_column.map do |i|
          row[i]
        end
      end
    end
    
    def render_with_template(template = @template)
      rendered = []
      csv.body.each_with_index do |row, i|
        title = title_content[i].join("\n")
        body = body_content[i].join("\n")
        erb = File.open(template, "rb").read
        r = ERB.new(erb, 0, '<>') if erb
        rendered << r.result(binding)
      end
      rendered.join("--------\n")
    end

  end
end