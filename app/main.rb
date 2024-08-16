require 'sinatra'
require_relative 'services/test_service'

set :bind, '0.0.0.0'

get '/tests' do
  content_type :json
  TestService.fetch_all_tests.to_json
end
