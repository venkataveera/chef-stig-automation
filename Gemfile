# encoding: utf-8
source 'https://rubygems.org'

gem 'inspec'

group :test do
  gem 'minitest', '~> 5.5'
  gem 'rake'
  gem 'simplecov', '~> 0.10'
end

group :integration do
  gem 'berkshelf', '~> 4.0'
  gem 'test-kitchen', '~> 1.4'
  gem 'kitchen-ec2'
  gem 'kitchen-inspec'
  gem 'concurrent-ruby', '~> 0.9'
end
