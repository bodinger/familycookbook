source 'https://rubygems.org'

# Project requirements
gem 'rake', '~> 10.3.2'

# Component requirements
gem 'erubis', '~> 2.7.0'
gem 'pg', '~> 0.17.1'
gem 'sequel', '~> 4.22.0'

gem 'rabl', '~> 0.11.3'
gem 'oj', '~> 2.11.0'
gem 'pry', '~> 0.10.1'

gem 'capistrano', '~> 2.15.5'
gem 'rvm-capistrano', '~> 1.5.3', :require => false


# Test requirements
group :test do
  gem 'rspec', '~> 2.99'
  gem 'rspec-collection_matchers'
  gem 'rack-test', '~> 0.6.2', :require => 'rack/test'
  gem 'ci_reporter', '~> 1.9.2'
  gem 'timecop', '~> 0.7.1'
  gem 'simplecov', '~> 0.8.2', :require => false
  gem 'json_spec', '~> 1.1.2'

  gem 'webmock', '~> 1.18.0', :require => false
  gem 'database_cleaner'
end

group :test, :development do
  gem 'thin', '~> 1.6.3'
  gem 'fabrication', '~> 2.11.3'
  gem 'faker', '~> 1.3.0'
  gem 'awesome_print', '~> 1.2.0'
end

group :integration, :staging, :production do
  gem 'puma', '~> 2.9.1'
end

%w(core support gen helpers cache mailer).each do |g|
  gem "padrino-#{g}", '0.12.4'
end
