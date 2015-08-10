require 'rails_helper'

RSpec.describe WebgrouperPatientCasesController, type: :controller do

  describe 'opening new form' do
    it 'should render the form' do
      get :new, locale: :de
      expect(response).to render_template(:form)
    end
  end

  describe 'index' do
    it 'should redirect to new' do
      get :index, locale: :de
      expect(subject).to redirect_to(action: :new)
    end
  end
end