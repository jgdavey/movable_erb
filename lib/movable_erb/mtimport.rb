module MovableErb
  class MTImport
    attr_accessor :csv
    attr_writer :title_column, :body_column
    
    def initialize(args = {})
      if args[:csv]
        @csv = Csv.new(args[:csv])
      end
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
      csv.body.map do |row|
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
    
    def render!
      rendered = []
      csv.body.each_with_index do |row, i|
        rendered << <<-EOT
TITLE: #{title_content[i].join("\n")}
-----
BODY:

#{body_content[i].join("\n")}

EOT
      end
      rendered.join("--------\n")
    end

  end
end