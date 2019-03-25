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
      get 'director/copyright_applications/accept/:id', to: 'directors#accept_copyright_applications'
      get 'director/copyright_applications/decline/:id', to: 'directors#decline_copyright_applications'

      post 'copyright_applications/tasks', to: 'copyright_application_tasks#create'
      put 'copyright_applications/tasks/:id', to: 'copyright_application_tasks#update'
      delete 'copyright_applications/tasks/:id', to: 'copyright_application_tasks#destroy'

      get 'secretaries/copyright_applications/accept/:id', to: 'secretaries#accept_copyright_applications'
      get 'secretaries/copyright_applications/decline/:id', to: 'secretaries#decline_copyright_applications'

      resources :products
      resources :copyright_applications
      get 'copyright_applications/submit/:id', to: 'copyright_applications#submit'
      get 'copyright_applications/unsubmit/:id', to: 'copyright_applications#unsubmit'
    end
  end
end
