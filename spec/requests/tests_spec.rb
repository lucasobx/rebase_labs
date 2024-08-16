require 'spec_helper'

RSpec.describe 'Test API', type: :request do
  it 'returns a list of tests' do
    get '/tests'
    
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
  end
end
