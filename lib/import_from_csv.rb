require 'bundler/setup'
require 'active_record'
require 'csv'
require 'yaml'
require 'erb'
require_relative '../app/models/test'

db_config = YAML.safe_load(ERB.new(File.read(File.expand_path('../config/database.yml', __dir__))).result)
ActiveRecord::Base.establish_connection(db_config['development'])

unless ActiveRecord::Base.connection.table_exists?(:tests)
  ActiveRecord::Base.connection.create_table :tests do |t|
    t.string :patient_cpf
    t.string :patient_name
    t.string :patient_email
    t.date :patient_birth_date
    t.string :patient_street_address
    t.string :patient_city
    t.string :patient_state
    t.string :doctor_license_number
    t.string :doctor_license_state
    t.string :doctor_name
    t.string :doctor_email
    t.string :exam_result_token
    t.date :exam_date
    t.string :exam_type
    t.string :exam_type_limits
    t.string :exam_type_result

    t.timestamps
  end
end

csv_file_path = File.expand_path('../data/data.csv', __dir__)

CSV.foreach(csv_file_path, col_sep: ';', headers: true) do |row|
  Test.create(
    patient_cpf: row['cpf'],
    patient_name: row['nome paciente'],
    patient_email: row['email paciente'],
    patient_birth_date: row['data nascimento paciente'],
    patient_street_address: row['endereço/rua paciente'],
    patient_city: row['cidade paciente'],
    patient_state: row['estado paciente'],
    doctor_license_number: row['crm médico'],
    doctor_license_state: row['crm médico estado'],
    doctor_name: row['nome médico'],
    doctor_email: row['email médico'],
    exam_result_token: row['token resultado exame'],
    exam_date: row['data exame'],
    exam_type: row['tipo exame'],
    exam_type_limits: row['limites tipo exame'],
    exam_type_result: row['resultado tipo exame']
  )
end