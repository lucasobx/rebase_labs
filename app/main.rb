require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/patient'
require_relative 'models/doctor'
require_relative 'models/test'
require_relative 'models/exam'

set :bind, '0.0.0.0'
set :database_file, '../config/database.yml'

get '/tests' do
  content_type :json
  tests = Test.includes(:patient, :doctor, :exams).all
  tests.map do |test|
    {
      result_token: test.exam_result_token,
      result_date: test.exam_date,
      patient: {
        cpf: test.patient.cpf,
        name: test.patient.name,
        email: test.patient.email,
        birth_date: test.patient.birth_date
      },
      doctor: {
        crm: test.doctor.license_number,
        crm_state: test.doctor.license_state,
        name: test.doctor.name,
        email: test.doctor.email
      },
      exams: test.exams.map do |exam|
        {
          type: exam.exam_type,
          limits: exam.exam_type_limits,
          result: exam.exam_type_result
        }
      end
    }
  end.to_json
end
