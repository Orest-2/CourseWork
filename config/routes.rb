Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      post 'admin/directors', to: 'admins#create'

      get 'user/params', to: 'user_params#show'
      post 'user/params', to: 'user_params#create'
      put 'user/params', to: 'user_params#update'
      
      get 'director/users', to: 'directors#index'
      post 'director/users', to: 'directors#create'
      delete 'director/users/:id', to: 'directors#destroy'

      post 'copyright_applications/tasks', to: 'copyright_application_tasks#create'
      put 'copyright_applications/tasks/:id', to: 'copyright_application_tasks#update'
      delete 'copyright_applications/tasks/:id', to: 'copyright_application_tasks#destroy'

      resources :products
      resources :copyright_applications
      get 'copyright_applications/submit/:id', to: 'copyright_applications#submit'
      get 'copyright_applications/unsubmit/:id', to: 'copyright_applications#unsubmit'
      get 'copyright_applications/accept/:id', to: 'copyright_applications#accept_copyright_applications'
      get 'copyright_applications/decline/:id', to: 'copyright_applications#decline_copyright_applications'
      get 'copyright_applications/share/:id', to: 'copyright_applications#sharing'
      get 'copyright_applications/done/:id', to: 'copyright_applications#done'

      get 'product/custom_search', to: 'custom_search#search'
    end
  end
end
