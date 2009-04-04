
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe MovableErb do
  it "should have class Csv" do
    MovableErb::Csv.should_not be_nil
  end
end

# EOF
