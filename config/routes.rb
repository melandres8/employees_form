Rails.application.routes.draw do
  root 'employees#index'
  resources :employees, except: [:show] do
    collection { post :import }
  end
end
