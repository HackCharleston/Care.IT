Digsouth::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  post 'merchants' => 'merchants#create'
  post 'transfers' => 'transfers#create'
  post 'users' => 'users#create'

  root :to => 'users#index'
end
