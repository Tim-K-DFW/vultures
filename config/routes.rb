Rails.application.routes.draw do
  root to: 'engine#params_entry'
  post '/params_entry', to: 'engine#generate'
  post '/results_performance', to: 'engine#results_performance'
  post '/results_positions', to: 'engine#results_positions'
  post '/results', to: 'engine#results'
end
