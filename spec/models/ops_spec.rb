require 'spec_helper'

describe OPS do
  it "should have the table name 'ops'" do
    OPS.table_name.should == "ops"
  end
end
