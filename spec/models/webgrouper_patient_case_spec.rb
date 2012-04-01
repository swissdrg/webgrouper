require 'spec_helper'

describe WebgrouperPatientCase do
  
  it "should not be persisted" do
    patient_case = WebgrouperPatientCase.new
    patient_case.persisted?.should be_false
  end
  
  describe "initializer" do
    
    before(:each) do
      @attr = { :entry_date => "20120312",
                :exit_date  => "20120314",
                :leave_days => 0, 
                :age_days   => 0, 
                :age_years  => 40, 
                :adm_weight => 250, 
                :adm => "99",
                :sep => "99",
                :los => 0,
                :sdf => "", 
                :hmv => 0,
                :sex => "M", 
                :pdx => "A000" }
    end
    
    it "should have an initialize method" do
      WebgrouperPatientCase.should respond_to :new
    end
    
    it "should return a valid webgrouper_patient_case given valid attributes" do
      patient_case = WebgrouperPatientCase.new(@attr)
      patient_case.should be_valid
    end
    
  end
  
end