Webgrouper::Application.routes.draw do

  scope 'statistics' do
    get 'webgrouper' => 'statistics#webgrouper'
    get 'batchgrouper' => 'statistics#batchgrouper'
    get 'webapi' => 'statistics#webapi'
  end

  scope "/:locale" do
    resources :webgrouper_patient_cases do
      get :autocomplete_Icd_code, :on => :collection
      get :autocomplete_Chop_code, :on => :collection
    end
    post 'create_query' => 'webgrouper_patient_cases#create_query'
    get 'create_query' => 'webgrouper_patient_cases#create_query'
    get 'help' => 'static_pages#help'
    get 'tos' => 'static_pages#tos'
    post 'batchgrouper' => 'batchgroupers#group'
    get 'batchgrouper' => 'batchgroupers#index'
    get 'index' => 'webgrouper_patient_cases#index'
    match 'parse' => 'webgrouper_patient_cases#parse'
  end


  scope 'webapi' do
    get '/' => 'webapi#index'
    match 'grouper/group' => 'webapi#group'
    match 'grouper/systems' => 'webapi#systems'
    match 'group' => 'webapi#group', :as => :webapi_group
    match 'systems' => 'webapi#systems', :as => :webapi_systems
  end

  get 'grouper' => 'batchgroupers#tos'
  get 'activate_beta' => 'webgrouper_patient_cases#activate_beta'
  get 'batchgrouper' => 'batchgroupers#tos'
  get 'webgrouper' => 'webgrouper_patient_cases#tos'
  get 'about' => 'static_pages#about'

  root :to => 'webgrouper_patient_cases#tos'
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', :to => 'errors#error_404'
  end
end
