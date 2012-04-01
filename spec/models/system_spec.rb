require 'spec_helper'

describe System do
  it "should have the table name 'system'" do
    System.table_name.should == "system"
  end
end
