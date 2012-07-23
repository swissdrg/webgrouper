require 'spec_helper'

describe Icd do
  it "should have the table name 'icd'" do
    Icd.table_name.should == "icd"
  end
end
