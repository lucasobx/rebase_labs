require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/test'

set :bind, '0.0.0.0'
set :database_file, '../config/database.yml'

get '/tests' do
  content_type :json
  Test.all.to_json
end
