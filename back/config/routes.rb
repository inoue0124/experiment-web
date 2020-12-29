Rails.application.routes.draw do

  # session
  get    '/login',                 to: 'sessions#new'
  post   '/login',                 to: 'sessions#create'
  delete '/logout',                to: 'sessions#destroy'

  # workflow
  get    '/workflow',          to: 'workflows#getWork'
  put    '/workflow/:id/complete', to: 'workflows#complete'
  put    '/workflow/undo',     to: 'workflows#undo'
  
  # user
  resources :users

  # experiment
  resources :experiments

  # assessment
  get    '/assessments/:id',       to: 'assessments#getAssessmentWork'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
