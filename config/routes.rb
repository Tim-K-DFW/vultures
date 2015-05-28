Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-status/web'

  root to: 'engine#params_entry'
  post '/params_entry', to: 'engine#generate'
  post '/results_performance', to: 'engine#results_performance'
  post '/results_positions', to: 'engine#results_positions'
  mount Sidekiq::Web, at: '/sidekiq'
  post '/results_link', to: 'engine#results_link'
end
