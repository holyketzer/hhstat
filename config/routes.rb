Hhstat::Application.routes.draw do
  #devise_for :users
  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' }
  
  resources :specializations

  get 'it/vacancy-count-by-month-in/(:year)', to: 'stat#count_by_month_in'  
  get 'it/vacancy-count-by-year', to: 'stat#count_by_year'
  get 'it/vacancy-count-by-month', to: 'stat#count_by_month'
  get 'it/vacancy-count-by-specialization', to: 'stat#count_by_specialization'
  get 'it/vacancy-count-by-class', to: 'stat#count_by_class'

  get 'it/salary-distribution-in/(:year)', to: 'stat#salary_distribution_in'
  get 'it/mean-salary-by-specialization-in/(:year)', to: 'stat#mean_salary_by_specialization_in'
  get 'it/salary-distribution-in/(:year)/for/(:specialization_name)', to: 'stat#salary_distribution_in_for', :specialization_name => /.*/

  resources :vacancies do
    member do
      get 'parse'
    end
    collection do
      get 'parse_all'
    end
  end

  resources :currencies do
    collection do
      get 'parse'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'site#index'
  get 'about', to: 'site#about'

  get 'supermaster', to: 'admin#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
