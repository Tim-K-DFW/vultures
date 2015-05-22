Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'engine#params_entry'
  post '/params_entry', to: 'engine#generate'
end
