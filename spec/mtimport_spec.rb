
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe MovableErb::MTImport do

  it "should exist" do
    MovableErb::MTImport.should_not be_nil
  end

  describe "initialization" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'does_not_exist.csv'})
      @mt.csv.stub!(:header).and_return(['Title','Body'])
      @mt.setup_column_nums
    end

    it "should have a title column in first column by default" do
      @mt.columns[:title].should eql([0])
    end

    it "should have a body column in second column by default" do
      @mt.columns[:body].should eql([1])
    end
  end
  
  describe "with non-default order of header rows" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'does_not_exist.csv'})
      @mt.csv.stub!(:header).and_return(['Body','Title'])
      @mt.setup_column_nums
    end

    it "should find and correctly assign the title column" do
      @mt.columns[:title].should eql([1])
    end
    
    it "should find and correctly assign the body column" do
      @mt.columns[:body].should eql([0])
    end
  end
  
  describe "joining field titles with same name" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'does_not_exist.csv'})
      @mt.csv.stub!(:header).and_return(['Title','Body','Body'])
      @mt.csv.stub!(:body).and_return([['A Title', 'Part of the body','is right here'],['Title 2', 'Body 2','is right here']])
      @mt.setup_column_nums
    end

    it "should find more than one element with Body if given" do
      @mt.columns[:body].should eql([1,2])
      @mt.content_for('body',0).should eql(['Part of the body','is right here'])
      @mt.content_for('body',1).should eql(['Body 2','is right here'])
    end
    
    
    it "should render with a template file" do
      @mt.render_with_template.should eql( 
      %q{TITLE: A Title
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

      }.gsub(/^ +/,'') )
    end
  end
  
  describe "non-default fields" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'spec/fixtures/example.csv'})
      @mt.csv.stub!(:header).and_return(['Title','Body','Category',"Extended"])
      @mt.csv.stub!(:body).and_return([['A Title', 'Part of the body','Articles','Another field'],['Title 2', 'Body 2','Articles','field 2']])
      @mt.setup_column_nums
    end

    it "should recognize an extended field" do
      @mt.columns[:extended].should_not be_nil
      @mt.columns[:extended].should be_instance_of(Array)
      @mt.columns[:extended].should eql([3])
    end
    
    it "should recognize the category field" do
      @mt.columns[:category].should_not be_nil
      @mt.columns[:category].should be_instance_of(Array)
      @mt.columns[:category].should eql([2])
    end
    
    it "should correctly render" do
      @mt.render_with_template.should eql(
      %q{TITLE: A Title
      CATEGORY: Articles
      -----
      BODY:

      Part of the body
      
      -----
      EXTENDED:
      
      Another field
      
      --------
      TITLE: Title 2
      CATEGORY: Articles
      -----
      BODY:
      
      Body 2
      
      -----
      EXTENDED:
      
      field 2
      
      }.gsub(/^ +/,''))
    end
  end
  
  describe "tags" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'spec/fixtures/example.csv'})
      @mt.csv.stub!(:header).and_return(['Title','Body','Tags'])
      @mt.csv.stub!(:body).and_return([['A Title', 'Body content','dog, cats, mice']])
      @mt.setup_column_nums
    end
    
    it "should recognize tags" do
      @mt.columns[:tags].should_not be_nil
    end
    
    it "should render correctly" do
      @mt.render_with_template.should eql(
      %q{TITLE: A Title
      TAGS: dog, cats, mice
      -----
      BODY:

      Body content
      
      }.gsub(/^ +/,''))
    end
  end
  
  describe "when header column is not named/misnamed" do
    before(:each) do
      @mt = MovableErb::MTImport.new(:csv => {:file => 'spec/fixtures/example.csv'})
      @mt.csv.stub!(:header).and_return(['Name','Address','Nothing'])
      @mt.csv.stub!(:body).and_return([['John Boy', '123 Nowhere Lane','dog, cats, mice']])
      @mt.setup_column_nums
    end
    
    it "should default the first field to title" do
      @mt.columns[:title].should_not be_nil
      @mt.columns[:title].should eql([0])
    end
    
    it "should default the second field to body" do
      @mt.columns[:body].should_not be_nil
      @mt.columns[:body].should eql([1])
    end
  end
  
end