require 'spec_helper'

describe Drg do
  
  it "should have the tablename 'drg'" do
    Drg.table_name.should == "drg"
  end
  
  describe ".reuptake_exception_for?" do
    
    it "should return true if the flag of the given drg is true" do
      dr_code = "A01A"
      Drg.reuptake_exception_for?(dr_code).should be_true
    end
    
  end
  
end
