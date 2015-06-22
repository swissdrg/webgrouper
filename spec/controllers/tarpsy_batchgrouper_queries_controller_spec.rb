require 'rails_helper'

RSpec.describe TarpsyBatchgrouperQueriesController, type: :controller do

  describe 'create' do
    it 'should result in an invalid query when submitting the empty form' do
      post :create, locale: :de, tarpsy_batchgrouper_query: {}
      tbq = assigns(:tarpsy_batchgrouper_query)
      expect(tbq).to_not be_valid
    end
  end

  describe 'new' do
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