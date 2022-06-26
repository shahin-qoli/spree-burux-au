source 'https://rubygems.org'

gem 'rails-controller-testing'
gem 'devise', github: 'heartcombo/devise', branch: 'main'

spree_opts = '>= 4.4.0'
gem 'spree', spree_opts
gem 'spree_backend', spree_opts
gem 'spree_emails', spree_opts
gem 'spree_frontend', spree_opts
gem 'rspec_junit_formatter', '~> 0.4.1'

if ENV['DB'] == 'mysql'
  gem 'mysql2'
else
  gem 'pg', '~> 1.1'
end

gem 'pry', '~> 0.14.1'
gem 'devise-two-factor', github: 'shahin-qoli/spree-brx-auth'
gem 'httparty'
gemspec
