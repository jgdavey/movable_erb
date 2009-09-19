Given /^I am on the commandline$/ do
  # dummy step
end

When /^I invoke the utility with the following CSV file:?$/ do |string|
  File.open(File.dirname(__FILE__) + '/tmp.csv', 'w') {|f| f.write(string) }  
  puts FasterCSV.parse(string).inspect
  @erb = MovableErb.new({:csv => File.dirname(__FILE__) + '/tmp.csv', :separator => ''})
end

Then /^I should see the following output:?$/ do |string|
  puts @erb.csv.to_hashes.inspect
  @erb.convert.should == string
end
