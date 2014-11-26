source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-flash'
gem 'thin'
gem 'haml'
gem 'rack','1.5.2'
gem 'data_mapper'
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'bcrypt'

group :development do
  gem 'sinatra-contrib'
  gem 'dm-sqlite-adapter'
  gem 'sqlite3'
end

group :production do

  gem "do_postgres"
  gem "pg"
  gem "dm-postgres-adapter"
end


group :test do
   gem 'rack-test'
   gem 'rake'
   gem 'minitest'
   gem 'test-unit'
   gem 'selenium-webdriver','2.43.0'
end