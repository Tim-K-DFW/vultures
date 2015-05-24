source 'https://rubygems.org'
ruby '2.0.0'
'rvm rvmrc warning ignore /home/action/workspace/mf_app/Gemfile'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt-ruby', '3.1.2'
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'turbolinks'
gem 'descriptive_statistics'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'capybara'
  gem 'vcr'
  gem 'webmock'
end

group :production, :staging do
  gem 'rails_12factor'
end
