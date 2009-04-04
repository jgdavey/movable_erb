
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe MovableErb::MTImport do

  it "should exist" do
    MovableErb::MTImport.should_not be_nil
  end

  describe "initialization" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'does_not_exist.csv'})
      @mt.csv.stub!(:header).and_return(['Title','Body'])
    end

    it "should have a title column in first column by default" do
      @mt.title_column.should eql([0])
    end

    it "should have a body column in second column by default" do
      @mt.body_column.should eql([1])
    end
  end
  
  describe "with non-default order of header rows" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'does_not_exist.csv'})
      @mt.csv.stub!(:header).and_return(['Body','Title'])
    end

    it "should find and correctly assign the title column" do
      @mt.title_column.should eql([1])
    end
    
    it "should find and correctly assign the body column" do
      @mt.body_column.should eql([0])
    end
  end
  
  describe "joining field titles with same name" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'does_not_exist.csv'})
      @mt.csv.stub!(:header).and_return(['Title','Body','Body'])
      @mt.csv.stub!(:body).and_return([['A Title', 'Part of the body','is right here'],['Title 2', 'Body 2','is right here']])
    end

    it "should find more than one element with Body if given" do
      @mt.body_column.should eql([1,2])
      @mt.body_content.first.should eql(['Part of the body','is right here'])
      @mt.body_content[1].should eql(['Body 2','is right here'])
    end
    
    it "should return a rendered template" do
      @mt.render!.should eql(<<-EOT
TITLE: A Title
-----
BODY:

Part of the body
is right here

--------
TITLE: Title 2
-----
BODY:

Body 2
is right here

EOT
)
    end
  end
  
end