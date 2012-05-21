require 'spec_helper'

describe WebgrouperPatientCase do
  
  before(:each) do
    @attr = { :entry_date => "",
              :exit_date  => "",
              :leave_days => 0, 
              :age_days   => 0, 
              :age_years  => 40, 
              :adm_weight => 250, 
              :adm => "99",
              :sep => "99",
              :los => 2,
              :sdf => "", 
              :hmv => 0,
              :sex => "M", 
              :pdx => "A000" }
  end
  
  it "should not be persisted" do
    patient_case = WebgrouperPatientCase.new
    patient_case.persisted?.should be_false
  end
  
  describe "initializer" do
    
    it "should have an initialize method" do
      WebgrouperPatientCase.should respond_to :new
    end
    
    it "should return a valid webgrouper_patient_case given valid attributes" do
      patient_case = WebgrouperPatientCase.new(@attr)
      patient_case.should be_valid
    end
    
  end
  
  describe "validations" do
    
    it "should fail if no attributes are given" do
      patient_case = WebgrouperPatientCase.new
      patient_case.manual_submission = true
      patient_case.should_not be_valid
    end
    
    it "should fail if sex is not present" do
      invalid_attr = @attr.merge(:sex => "")
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if leave_days are not greate than or equal to 0" do
      invalid_attr = @attr.merge(:leave_days => -15)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if age in years is negative" do
      invalid_attr = @attr.merge(:age_mode => "years", :age => -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if age in years is greater than 125" do
      invalid_attr = @attr.merge(:age_mode => "years", :age => 126)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if age in days is negative" do
      invalid_attr = @attr.merge(:age_mode => "days", :age => -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if age in days is greater than 367" do
      invalid_attr = @attr.merge(:age_mode => "days", :age => 368)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if adm_weight is less than 250" do
      invalid_attr = @attr.merge(:age_mode => "days", :adm_weight => 249)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if adm_weight is greater than 20000" do
      invalid_attr = @attr.merge(:age_mode => "days", :adm_weight => 20001)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if adm is not present" do
      invalid_attr = @attr.merge(:adm => "")
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if sep is not present" do
      invalid_attr = @attr.merge(:sep => "")
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if los is negative" do
      invalid_attr = @attr.merge(:los => -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end

    it "should fail if hmv is negative" do
      invalid_attr = @attr.merge(:hmv => -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if pdx is not registered in the webgrouper database" do
      invalid_attr = @attr.merge(:pdx => "InvalidCode")
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if one of the secondary diagnoses is not registered in the webgrouper database" do
      invalid_attr = @attr.merge(:diagnoses => { 0 => "Invalid icd", 1 => "A000" })
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if one of the procedures is not registered in the webgrouper database" do
      invalid_attr = @attr.merge(:procedures => { 0 => { 0 => "Invalid op", 1 => "bla", 2 => "bla" }, 1 => { 0 => "0001", 1 => "bla", 2 => "ginger" } })
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
    it "should fail if the procedure 'triple' consists of a date or laterality, but no code" do
      invalid_attr = @attr.merge(:procedures => { 0 => { 0 => "", 1 => "L", 2 => "12.04.2012" } })
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      patient_case.should_not be_valid
    end
    
  end
  
end