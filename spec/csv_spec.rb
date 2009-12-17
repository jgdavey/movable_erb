require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

TEMPLATE_FIXTURE = File.expand_path(File.dirname(__FILE__) + '/fixtures/template.erb')
CSV_FIXTURE = File.expand_path(File.dirname(__FILE__) + '/fixtures/example.csv')


if RUBY_VERSION =~ /1.9/
  $csv_library = ::CSV
else
  $csv_library = FasterCSV
end

describe MovableErb do
  it "should have a CSV instance" do
    m = MovableErb.new
    m.csv = MovableErb::CSV.setup do |csv|
      csv.filename = CSV_FIXTURE
    end.should be_a(MovableErb::CSV)
  end

  it "should have an Erb instance" do
    m = MovableErb.new
    m.erb = MovableErb::Erb.setup do |erb|
      true
    end.should be_a(MovableErb::Erb)
  end

  context "#convert" do
    before(:each) do
      @m = MovableErb.new
    end
    it "should raise an error if it's missing a CSV and/or Erb instance" do
      lambda { @m.convert }.should raise_error 
    end

    it "should raise an error if it's CSV instance can't parse!" do
      @m.erb = MovableErb::Erb.setup { |erb| erb.template = TEMPLATE_FIXTURE }
      @m.csv = "Random string"
      lambda { @m.convert }.should raise_error(NoMethodError, "undefined method `parse!' for \"Random string\":String")
    end

    it "should raise an error if it's missing an Erb instance" do
      String.any_instance.stubs(:data=).returns('')
      @m.csv = MovableErb::CSV.setup { |csv| csv.filename = CSV_FIXTURE }
      @m.erb = "Random string"
      lambda { @m.convert }.should raise_error(NoMethodError, "undefined method `build!' for \"Random string\":String")
    end

    it "should convert the CSV to a string with the Erb template" do
      @m.csv = MovableErb::CSV.setup { |csv| csv.filename = CSV_FIXTURE }
      @m.erb = MovableErb::Erb.setup { |erb| erb.template = TEMPLATE_FIXTURE }
      @m.separator = "\n"
      @m.convert.should == <<-ERB.gsub(/^ +/, "")
      Name: John
      Email: john@example.com

      Name: Abigail
      Email: abby@example.com

      Name: Bernard

      Name: Casius
      ERB
    end
  end

  context "initilization" do
    it "should take a hash of options" do
      m = MovableErb.new({:hash => 'of options'})
      m.should be_a(MovableErb)
    end

    it "should set the template file" do
      m = MovableErb.new({ :template => TEMPLATE_FIXTURE })
      m.erb.template.should == File.read(TEMPLATE_FIXTURE)
    end

    it "should set the csv file" do
      m = MovableErb.new({ :csv => CSV_FIXTURE })
      m.csv.filename.should == CSV_FIXTURE 
    end
    
    it "should set a separator if given" do
      m = MovableErb.new({ :separator  => ', ' })
      m.separator.should == ', '
    end
  end
  
  context "full-on run-through" do
    it "should work!" do
      movable_erb = MovableErb.new({
        :csv => File.expand_path(File.dirname(__FILE__) + '/fixtures/advanced.csv'),
        :separator => ''
      })
      movable_erb.convert.should == <<-ERB.gsub(/^ +/, "")
        TITLE: Hambone
        CATEGORY: Silly
        CATEGORY: Blah
        -----
        BODY:
        
        This is the content for hambone
        
        --------
        TITLE: WillyNilly
        -----
        BODY:
        
        More body
        
        --------
      ERB
    end
  end
end

describe MovableErb::CSV do
  it "should be an instance of itself" do
    MovableErb::CSV.new.should be_a(MovableErb::CSV)
  end

  describe "setup" do
    before(:each) do
      @csv = MovableErb::CSV.new
    end

   context "shortcut setup class method" do
      before(:each) do
        MovableErb::CSV.any_instance.stubs(:filename).returns("fake")
        $csv_library.stubs(:read).returns([])
      end

      it "should create a new instance" do
        MovableErb::CSV.setup do |csv|
          csv.should be_a(MovableErb::CSV)
        end
      end

      it "should return the new instance" do
        MovableErb::CSV.setup { |csv| @instance = csv }.should == @instance
      end

      it "should return the new instance (2)" do
        MovableErb::CSV.setup do |csv|
          @instance = csv
          'fakey fake string'
        end.should == @instance
      end

      it "should raise an error if no block given" do
        lambda { MovableErb::CSV.setup }.should raise_error('no block given')
      end

      it "should call parse!" do
        MovableErb::CSV.any_instance.expects(:parse!)
        MovableErb::CSV.setup { |csv| true }
      end
    end
  end

  describe "parsing" do
    before(:each) do
      $csv_library.stubs(:read).returns([["row1"], ["row2"]])
      @csv = MovableErb::CSV.new
      @csv.filename = "test.csv"
    end

    it "#parse! should return self" do
      @csv.parse!.should == @csv
    end

    it "#parse! should modify attribute hashes (via to_hashes)" do
      @csv.expects(:to_hashes)
      @csv.parse!
    end

    context "#to_hashes" do
      it "should read from file" do
        $csv_library.expects(:read).with("test.csv").returns([[]])
        @csv.to_hashes
      end

      it "should return an array of hashes (1 rows, 1 column)" do
        @csv.to_hashes.should == [{'row1' => ['row2']}]
      end

      it "should downcase the header row" do
        $csv_library.stubs(:read).returns([["Name"],["Billy Bob"]])
        @csv.to_hashes.should == [{'name' => ['Billy Bob']}]
      end
      
      it "should convert the header row to snake_case" do
        $csv_library.stubs(:read).returns([["Extended Body"],["Billy Bob"]])
        @csv.to_hashes.should == [{'extended_body' => ['Billy Bob']}] 
      end

      it "should return an array of hashes (3 rows, 3 columns)" do
        $csv_library.stubs(:read).returns([["Name", "Phone", "Email"], 
        ["John", "773-123-1234", "john@example.com"], 
        ["Abigail", nil, "abby@example.com"], 
        ["Casius", nil, nil]])
        @csv.to_hashes.should == [
          {'name' => ['John'],    'phone' => ['773-123-1234'], 'email' => ['john@example.com'] },
          {'name' => ['Abigail'], 'email' => ['abby@example.com'] },
          {'name' => ['Casius'],}
        ]
      end

      it "should collect values with the same key" do
        $csv_library.stubs(:read).returns([["Name", "Name", "Email"], ["John", "James", "john@example.com"]]) 
        @csv.to_hashes.should == [{'name' => ['John', 'James'],'email' => ['john@example.com']}]
      end

      it "should collect values with the same key (more than 2)" do
        $csv_library.stubs(:read).returns([["Name", "Name", "Name"], ["John", "James", "Jill"]]) 
        @csv.to_hashes.should == [{'name' => ['John', 'James', 'Jill']}]
      end
    end
  end
end

describe MovableErb::Erb do
  context "initializing" do
    it "should initialize with a template file" do
      MovableErb::Erb.new.should be_a(MovableErb::Erb)
    end
  end

  context "loading a template" do
    it "template setter should load a file into @template" do
      File.expects(:read).with("filename.erb").returns("This is a template")
      @erb = MovableErb::Erb.new
      @erb.template = 'filename.erb'
      @erb.template.should == 'This is a template'
    end
  end

  context "data hash" do
    it "should accept a data hash" do
      @erb = MovableErb::Erb.new
      @erb.data = {'these' => 'params'}
      @erb.data.should == {'these' => 'params'}
    end
  end

  context "shortcut setup class method" do
    it "should create a new instance" do
      MovableErb::Erb.setup do |erb|
        erb.should be_a(MovableErb::Erb)
      end
    end

    it "should return the new instance" do
      MovableErb::Erb.setup { |erb| @instance = erb }.should == @instance
    end

    it "should return the new instance (2)" do
      MovableErb::Erb.setup do |erb|
        @instance = erb
        'fakey fake string'
      end.should == @instance
    end

    it "should raise an error if no block given" do
      lambda { MovableErb::Erb.setup }.should raise_error('no block given')
    end
  end

  context "#build!" do
    before(:each) do
      @erb = MovableErb::Erb.new
    end

    it "should create a new ERB instance with @template" do
      @erb.stubs(:template).returns("string")
      ERB.expects(:new)
      @erb.build!
    end

    it "should set @parsed_string" do
      @erb.stubs(:template).returns("string")
      @erb.build!
      @erb.parsed_string.should_not be_nil
    end

    it "should parse a template with data given" do
      @erb.template = TEMPLATE_FIXTURE
      @erb.data = {'name' => ['Johnny'], 'email' => ['john@example.com']}
      @erb.build!
      @erb.parsed_string.should == <<-ERB.gsub(/^\s+/,'')
      Name: Johnny
      Email: john@example.com
      ERB
    end
  end
end
