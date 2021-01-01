Rails.application.routes.draw do

  # session
  get    '/login',                 to: 'sessions#new'
  post   '/login',                 to: 'sessions#create'
  delete '/logout',                to: 'sessions#destroy'

  # workflow
  get    '/workflow',          to: 'workflows#getWork'
  put    '/workflow/:workflow_id/complete', to: 'workflows#complete'
  put    '/workflow/undo',     to: 'workflows#undo'
  get    '/works',             to: 'workflows#getWorkMaster'
  
  # user
  resources :users
  post    '/users/bulk',       to: 'users#bulkCreate'

  # experiment
  resources :experiments

  # agreement
  get    '/agreements/:workflow_id',  to: 'agreements#show'

  # assessment
  get    '/assessments/:workflow_id', to: 'assessments#getAssessmentWork'
  post   '/assessments/:workflow_id', to: 'assessments#update'

  # questionnaire
  get    '/questionnaires/:workflow_id', to: 'questionnaires#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
