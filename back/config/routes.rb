Rails.application.routes.draw do

  # session
  get    '/session',                 to: 'sessions#show'
  post   '/session',                 to: 'sessions#create'
  delete '/session',                to: 'sessions#destroy'

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

  # facesheet
  get    '/facesheets/:workflow_id',  to: 'facesheets#show'
  post   '/facesheets',               to: 'facesheets#create'

  # assessment
  get    '/assessments/:workflow_id', to: 'assessments#getAssessmentWork'
  post   '/assessments/:workflow_id', to: 'assessments#update'

  # questionnaire
  get    '/questionnaires/:workflow_id', to: 'questionnaires#show'

  # aws
  post '/presigned', to: 's3#getPresignedUrl'
  post '/download',  to: 's3#download'
  post '/upload',    to: 's3#upload'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
