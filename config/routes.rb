Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      post 'create_admin', to: 'super_admin#create_admin'
      get 'admin_index', to: 'admins#index'
      post 'admin_create_acount', to: 'admins#create'
      delete 'admin_destroy_acount/:id', to: 'admins#destroy'
      resources :products
      resources :applications
    end
  end
end
