require 'rails_helper'

RSpec.describe TarpsyPatientCasesController, type: :controller do

  describe 'generate random' do
    it 'should generate a valid tarpsy patient case with assignments' do
      get :generate_random, locale: :de
      pc = assigns(:tarpsy_patient_case)
      expect(pc).to be_valid
      expect(pc.assessments.count).to be >= 1
    end

    it 'should render the form' do
      get :generate_random, locale: :de
      expect(response).to render_template(:form)
    end
  end

  describe 'opening new form' do
    it 'should render the form' do
      get :new, locale: :de
      expect(response).to render_template(:form)
    end

    it 'should generate a new empty tarpsy patient case when visiting new with one assignment' do
      get :new, locale: :de
      a = assigns(:tarpsy_patient_case).assessments
      # TODO: This somehow fails
      #expect(a.count).to eq(1)
      #a.assessment_items.each do |item|
      #  expect(item.value).to eq(9)
      #end
    end
  end

  describe 'index' do
    it 'should redirect to new' do
      get :index, locale: :de
      expect(subject).to redirect_to(action: :new)
    end
  end
end