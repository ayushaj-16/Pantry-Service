Rails.application.routes.draw do
  get 'login/create'

  scope :food_item do
    post '/rating', to: 'food_item#rating_update'
  end
  # Ex:- scope :active, -> {where(:active => true)}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :food_item, only: %i[index create update destroy]
  resources :order, only: %i[index show create update destroy]
  resources :login, only: %i[create]
end
