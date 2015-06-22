Webgrouper::Application.routes.draw do

  scope 'statistics' do
    get '/' => 'statistics#index'
    get 'webgrouper_stats' => 'statistics#webgrouper'
    get 'batchgrouper_stats' => 'statistics#batchgrouper'
    get 'webapi_stats' => 'statistics#webapi'
  end

  scope "/:locale" do
    resources :webgrouper_patient_cases, only: [:index, :new, :create] do
      collection do
        patch '/' => 'webgrouper_patient_cases#create'
      end
    end
    resources :tarpsy_patient_cases, only: [:index, :new, :create] do
      collection do
        patch '/' => 'tarpsy_patient_cases#create'
        get 'generate_random' => 'tarpsy_patient_cases#generate_random'
      end
    end

    resources :tarpsy_batchgrouper_queries, only: [:index, :new, :create] do
      collection do
        patch '/' => 'tarpsy_batchgrouper_queries#create'
      end
    end
    get 'help' => 'static_pages#help'
    get 'tos' => 'static_pages#tos'
    post 'batchgrouper' => 'batchgroupers#group'
    get 'batchgrouper' => 'batchgroupers#index'
    match 'parse' => 'webgrouper_patient_cases#parse', via: [:get, :post]
    get 'autocomplete_icd_code' => 'webgrouper_patient_cases#autocomplete_icd_code'
    get 'autocomplete_chop_code' => 'webgrouper_patient_cases#autocomplete_chop_code'
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

  # Visitors of tarps.swissdrg.org should be redirected to tarpsy form.
  constraints subdomain: 'tarpsy' do
    get '/' => 'tarpsy_patient_cases#tos'
  end

  root :to => 'webgrouper_patient_cases#tos'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', :to => 'errors#error_404', via: [:get, :post]
  end
end
