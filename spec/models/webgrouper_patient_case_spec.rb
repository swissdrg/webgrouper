require 'rails_helper'

RSpec.describe WebgrouperPatientCase, type: :model do
  
  before(:each) do
    @attr = {entry_date: '',
             exit_date: '',
             leave_days: 0,
             age: 40,
             age_mode: 'years',
             adm_weight: 250,
             adm: '99',
             sep: '99',
             los: 2,
             hmv: 0,
             sex: 'M',
             pdx: 'A000'}
  end

  describe 'initializer' do
    
    it 'should have an initialize method' do
      expect(WebgrouperPatientCase).to respond_to(:new)
    end
    
    it 'should return a valid webgrouper_patient_case given valid attributes' do
      patient_case = WebgrouperPatientCase.new(@attr)
      expect(patient_case).to be_valid
    end
    
  end
  
  describe 'validations' do
    it 'should fail if sex is not present' do
      invalid_attr = @attr.merge(sex: '')
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if leave_days are not greate than or equal to 0' do
      invalid_attr = @attr.merge(leave_days: -15)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if age in years is negative' do
      invalid_attr = @attr.merge(age_mode: 'years', age: -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if age in years is greater than 125' do
      invalid_attr = @attr.merge(age_mode: 'years', age: 126)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if age in days is negative' do
      invalid_attr = @attr.merge(age_mode: 'days', age: -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if age in days is greater than 367' do
      invalid_attr = @attr.merge(age_mode: 'days', age: 368)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if adm_weight is less than 125' do
      invalid_attr = @attr.merge(age_mode: 'days', adm_weight: 124)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if adm_weight is greater than 20000' do
      invalid_attr = @attr.merge(age_mode: 'days', adm_weight: 20001)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if adm is not present' do
      invalid_attr = @attr.merge(adm: '')
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if sep is not present' do
      invalid_attr = @attr.merge(sep: '')
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if los is negative' do
      invalid_attr = @attr.merge(los: -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if hmv is negative' do
      invalid_attr = @attr.merge(hmv: -1)
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if pdx is not registered in the webgrouper database' do
      invalid_attr = @attr.merge(pdx: 'InvalidCode')
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if one of the secondary diagnoses is not registered in the webgrouper database' do
      invalid_attr = @attr.merge(diagnoses: ['Invalid icd', 'A000'])
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it 'should fail if one of the procedures is not registered in the webgrouper database' do
      invalid_attr = @attr.merge(procedures: [{'c' => 'Invalid op', 'l' => 'bla', 'd' => 'bla'},
                                              {'c' => '0001', 'l' => 'bla', 'd' => 'ginger'}])
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it "should fail if the procedure 'triple' consists of a date or laterality, but no code" do
      invalid_attr = @attr.merge(procedures: [{'c' => '', 'l' => 'L', 'd' => '12.04.2012'}])
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end

    it "should succeed if theres a valid procedure without date nor laterality" do
      invalid_attr = @attr.merge(procedures: [{'c' => '00.00', 'l' => '', 'd' => ''}])
      patient_case = WebgrouperPatientCase.new(invalid_attr)
      expect(patient_case).to_not be_valid
    end


  end
  
end