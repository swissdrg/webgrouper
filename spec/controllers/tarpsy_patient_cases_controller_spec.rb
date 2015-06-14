require 'rails_helper'

RSpec.describe TarpsyPatientCasesController, type: :controller do

  describe 'generate random' do
    it 'should generate a valid' do
      get :generate_random, locale: :de
      expect(assigns(:tarpsy_patient_case)).to be_valid
    end

    it 'should render the form' do
      get :generate_random, locale: :de
      expect(response).to render_template(:form)
    end
  end
end