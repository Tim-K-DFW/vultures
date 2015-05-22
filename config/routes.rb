Rails.application.routes.draw do
  root to: 'engine#params_entry'
  post '/params_entry', to: 'engine#generate'
  get '/results_performance', to: 'engine#results_performance'
  get '/results_positions', to: 'engine#results_positions'
end
