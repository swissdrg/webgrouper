Webgrouper::Application.routes.draw do

  scope "/:locale" do
    resources :webgrouper_patient_cases do
      get :autocomplete_Icd_code, :on => :collection
      get :autocomplete_Chop_code, :on => :collection
    end
    get 'create_query'  => 'webgrouper_patient_cases#create_query'
    get 'help' => 'static_pages#help'
    get 'tos' => 'static_pages#tos'
    get 'about' => 'static_pages#about'
  end
  
  # This is for testing only and can be removed later on:
  get 'test404' => 'errors#error_404'
  get 'test500' => 'errors#error_500'
  
  root :to => 'webgrouper_patient_cases#index'
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', :to => 'errors#error_404'
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
