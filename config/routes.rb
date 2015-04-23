Webgrouper::Application.routes.draw do

  scope 'statistics' do
    get '/' => 'statistics#index'
    get 'webgrouper_stats' => 'statistics#webgrouper'
    get 'batchgrouper_stats' => 'statistics#batchgrouper'
    get 'webapi_stats' => 'statistics#webapi'
  end

  scope "/:locale" do
    resources :webgrouper_patient_cases do
      get :autocomplete_Icd_code, :on => :collection
      get :autocomplete_Chop_code, :on => :collection
    end
    match 'create_query' => 'webgrouper_patient_cases#create_query', via: [:get, :post]
    get 'help' => 'static_pages#help'
    get 'tos' => 'static_pages#tos'
    post 'batchgrouper' => 'batchgroupers#group'
    get 'batchgrouper' => 'batchgroupers#index'
    get 'index' => 'webgrouper_patient_cases#index'
    match 'parse' => 'webgrouper_patient_cases#parse', via: [:get, :post]
  end


  scope 'webapi' do
    get '/' => 'webapi#index'
    match 'grouper/group' => redirect('/webapi/group'), via: [:get, :post]
    match 'grouper/systems' => redirect('/webapi/systems'), via: [:get, :post]
    match 'group' => 'webapi#group', :as => :webapi_group, via: [:get, :post]
    match 'systems' => 'webapi#systems', :as => :webapi_systems, via: [:get, :post]
  end

  get 'grouper' => 'batchgroupers#tos'
  get 'activate_beta' => 'webgrouper_patient_cases#activate_beta'
  get 'batchgrouper' => 'batchgroupers#tos'
  get 'webgrouper' => 'webgrouper_patient_cases#tos'
  get 'about' => 'static_pages#about'

  root :to => 'webgrouper_patient_cases#tos'
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', :to => 'errors#error_404', via: [:get, :post]
  end
end
