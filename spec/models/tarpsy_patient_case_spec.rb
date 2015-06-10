require 'rails_helper'

RSpec.describe TarpsyPatientCase, type: :model do

  def create_valid_assessment_items
    (0...12).each_with_object({}) { |k, h| h[k.to_s] = { value: AssessmentItem::VALID_VALUES.sample } }
  end

  before(:each) do
    @attr = {entry_date: '01.01.2015',
             exit_date: '31.01.2015',
             leave_days: 0,
             pdx: 'F30.0',
             assessments_attributes: { '0' => {date: '02.01.2015', assessment_items_attributes: create_valid_assessment_items }}
    }
  end



  describe 'validations' do

    it 'should succeed with default attr' do
      patient_case = TarpsyPatientCase.new(@attr)
      patient_case.assessments.each do |ass|
        expect(ass).to be_valid
      end
      expect(patient_case).to be_valid
    end

    it 'should fail with an invalid pdx' do
      patient_case = TarpsyPatientCase.new(@attr.merge(pdx: 'asdf'))
      expect(patient_case).to_not be_valid
      expect(patient_case.errors[:pdx]).to_not be_empty
    end

    it 'should fail without entry_date' do
      patient_case = TarpsyPatientCase.new(@attr.merge(entry_date: ''))
      expect(patient_case).to_not be_valid
      expect(patient_case.errors[:entry_date]).to_not be_empty
    end

    it 'should fail if an assessment item has an invalid value' do
      items = create_valid_assessment_items
      items['0'][:value] = 7
      assessments = { assessments_attributes: { '0' => {date: '02.01.2015', assessment_items_attributes: items }}}
      patient_case = TarpsyPatientCase.new(@attr.merge(assessments))
      expect(patient_case).to_not be_valid
      expect(patient_case.errors[:assessments]).to_not be_empty
    end
    
  end

end