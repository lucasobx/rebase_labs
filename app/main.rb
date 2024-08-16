require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/patient'
require_relative 'models/doctor'
require_relative 'models/test'
require_relative 'models/exam'
require_relative 'services/test_service'

set :bind, '0.0.0.0'
set :database_file, '../config/database.yml'

get '/tests' do
  content_type :json
  TestService.fetch_all_tests.to_json
end
