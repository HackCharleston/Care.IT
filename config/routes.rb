Digsouth::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  resources :transfers

  resources :users do
    collection do
      post :save_finger
    end
  end

  resources :merchants

  resources :captures do 
    collection do
      get :todays
    end
  end

  root :to => 'users#index'
end