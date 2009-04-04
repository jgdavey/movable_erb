
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe MovableErb::Csv do
  describe "intialization" do

    before(:each) do
      @csv = MovableErb::Csv.new({:file => 'example.csv'})
    end

    it "should accept arguments" do
      @csv.should_not be_nil
    end

    it "should have @file attribute match passed in value" do
      @csv.file.should eql('example.csv')
    end

  end
  
  describe "opening the file" do
    before(:each) do
      @file_to_open = File.join(File.dirname(__FILE__), 'fixtures', 'example.csv')
      @csv = MovableErb::Csv.new({:file => @file_to_open})
    end

    it "should find the file" do
      File.open(@file_to_open).should_not be_nil
    end

    it "should populate rows" do
      @csv.rows.should_not be_nil
    end
  end
  
  describe "rows" do
    before(:each) do
      @file_to_open = File.join(File.dirname(__FILE__), 'fixtures', 'example.csv')
      @csv = MovableErb::Csv.new({:file => @file_to_open})
    end

    it "should be an array of arrays" do
      @csv.rows.should be_instance_of(Array)
      @csv.rows.each do |row|
        row.should be_instance_of(Array)
      end
    end

    it "should have a header row" do
      @csv.header.should eql(['Name','Phone','Email'])
    end

    it "should exclude header from data" do
      @csv.data.first.should_not eql(['Name','Phone','Email'])
    end
    
    it "should should have data" do
      @csv.data.first.should eql(['John','773-123-1234','john@example.com'])
    end
  end
end

# EOF
