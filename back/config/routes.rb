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
  resources :experiments, :except => :getProgress
  post    '/experiments/progress', to: 'experiments#getProgress'

  # agreement
  get    '/agreements/:workflow_id',  to: 'agreements#show'

  # facesheet
  get    '/facesheets/data/:t_facesheet_id',  to: 'facesheets#showDFacesheet'
  get    '/facesheets/:workflow_id',  to: 'facesheets#show'
  get    '/facesheets',               to: 'facesheets#index'
  post   '/facesheets/:workflow_id',  to: 'facesheets#create'
  put    '/facesheets/:workflow_id',  to: 'facesheets#update'

  # instruction
  get    '/instructions/:workflow_id', to: 'instructions#getInstruction'

  # assessment
  get    '/assessments/search',  to: 'assessments#search'
  get    '/assessments/practice/:workflow_id', to: 'assessments#getPracticeAssessmentData'
  get    '/assessments/:workflow_id', to: 'assessments#getAssessment'
  get    '/assessments/data/:workflow_id', to: 'assessments#getAssessmentData'
  post   '/assessments/data/:workflow_id', to: 'assessments#updateAssessmentData'

  # questionnaire
  get    '/questionnaires/:workflow_id', to: 'questionnaires#show'
  get    '/questionnaires',              to: 'questionnaires#index'

  # transfer
  get    '/transfers/:workflow_id',  to: 'transfers#show'

  # aws
  post '/presigned', to: 's3#getPresignedUrl'
  post '/file',  to: 's3#download'
  delete '/file',    to: 's3#delete'
  post '/files/zip', to: 's3#downloadZip'
  post '/files',    to: 's3#upload'
  post '/undisclosedFiles', to: 's3#listUndisclosedFiles'
  post '/disclosedFiles', to: 's3#listDisclosedFiles'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
