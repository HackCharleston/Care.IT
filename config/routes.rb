Digsouth::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  resources :transfers

  resources :users do
    get :save_finger
  end

  resources :merchants

  resources :captures do 
    collection do
      get :todays
    end
  end

  root :to => 'users#index'
end