require 'spec_helper'

describe DRG do
  
  it "should have the tablename 'drg'" do
    DRG.table_name.should == "drg"
  end
  
  describe ".reuptake_exception_for?" do
    
    it "should return true if the flag of the given drg is true" do
      dr_code = "A01A"
      DRG.reuptake_exception_for?(dr_code).should be_true
    end
    
  end
  
end
