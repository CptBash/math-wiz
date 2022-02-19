Rails.application.routes.draw do
  get 'health_check/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # root "calculations#index"
  resources :calculations, only: [:index, :show, :create, :destroy]
end
