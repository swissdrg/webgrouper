require 'spec_helper'

describe ICD do
  it "should have the table name 'icd'" do
    ICD.table_name.should == "icd"
  end
end
