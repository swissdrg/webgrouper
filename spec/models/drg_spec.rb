require 'spec_helper'

describe DRG do
  
  it "should have the tablename 'drg'" do
    DRG.table_name.should == "drg"
  end
  
end
