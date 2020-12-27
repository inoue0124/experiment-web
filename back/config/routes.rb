Rails.application.routes.draw do
  resources :experiments
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/workflow/next', to: 'workflows#getNextWork'
  put    '/workflow/complete', to: 'workflows#complete'
  put    '/workflow/undo', to: 'workflows#undo'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
