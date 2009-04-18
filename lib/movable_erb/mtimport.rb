module MovableErb
  class MTImport
    require 'erb'
    
    COLUMNNAMES = ['title','body','extended', 'category', 'tags']
    
    attr_accessor :csv, :template, :body_content, :extended, :columns
    attr_writer :title_column
    
    def initialize(args = {})
      if args[:csv]
        @csv = Csv.new(args[:csv])
        @columns = {:body => nil, :title => nil}
      end
        @template = args[:template] || File.join(File.dirname(__FILE__), 'templates', 'default.erb')
    end
    
    def header_rows
      if @csv
        @csv.header
      else
        raise "No CSV file"
      end
    end
    
    def setup_column_nums
      COLUMNNAMES.each do |colname|
        @columns[colname.to_sym] = header_rows.to_enum(:each_with_index).collect do |x,i| 
          i if x.downcase == colname
        end.compact  
      end
      @columns
    end
    
    def column_nums_for(column)
      @columns[column.to_sym]
    end
    
    def content_for(column, row = 0)
      content = column_nums_for(column).map do |i|
        csv.body[row][i]
      end
    end

    
    def render_with_template(template = @template)
      rendered = []
      csv.body.each_with_index do |row, i|
        title = content_for('title', i).join(" ")
        body = content_for('body', i).join("\n")
        extended = content_for('extended', i).join("\n")
        category = content_for('category', i).join(" ")
        tags = content_for('tags', i).join(", ")
        erb = File.open(template, "rb").read
        r = ERB.new(erb, 0, '<>') if erb
        b = binding
        rendered << r.result(b)
      end
      rendered.join("--------\n")
    end
    
  end
end