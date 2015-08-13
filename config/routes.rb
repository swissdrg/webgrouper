Webgrouper::Application.routes.draw do

  resources :statistics, only: :index do
    collection do
      get 'webgrouper_patient_cases'
      get 'batchgrouper_queries'
      get 'webapi_queries'
      get 'tarpsy_patient_cases'
      get 'tarpsy_batchgrouper_queries'
    end
  end

  scope "/:locale" do
    resources :webgrouper_patient_cases, only: [:index, :new, :create] do
      collection do
        patch '/' => 'webgrouper_patient_cases#create'
        match 'parse', via: [:get, :post]
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
    resources :batchgrouper_queries, only: [:index, :new, :create] do
      collection do
        patch '/' => 'batchgrouper_queries#create'
      end
    end
    get 'help' => 'static_pages#help'
    get 'tos' => 'static_pages#tos'
    get 'autocomplete_icd_code' => 'webgrouper_patient_cases#autocomplete_icd_code'
    get 'autocomplete_chop_code' => 'webgrouper_patient_cases#autocomplete_chop_code'
  end

  resources :webapi_queries, path: 'webapi', as: 'webapi', only: [:index, :create] do
    collection do
      post 'group'
      match 'systems', via: [:get, :post]
    end
  end

  get 'grouper' => 'batchgrouper_queries#tos'
  get 'activate_beta' => 'webgrouper_patient_cases#activate_beta'
  get 'batchgrouper' => 'batchgrouper_queries#tos'
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
