require 'bundler/setup'
require 'active_record'
require 'csv'
require 'yaml'
require 'erb'
require_relative '../app/models/patient'
require_relative '../app/models/doctor'
require_relative '../app/models/test'
require_relative '../app/models/exam'

db_config = YAML.safe_load(ERB.new(File.read(File.expand_path('../config/database.yml', __dir__))).result)
ActiveRecord::Base.establish_connection(db_config['development'])

unless ActiveRecord::Base.connection.table_exists?(:patients)
  ActiveRecord::Base.connection.create_table :patients do |t|
    t.string :cpf
    t.string :name
    t.string :email
    t.date :birth_date
    t.string :street_address
    t.string :city
    t.string :state
    t.timestamps
  end
end

unless ActiveRecord::Base.connection.table_exists?(:doctors)
  ActiveRecord::Base.connection.create_table :doctors do |t|
    t.string :license_number
    t.string :license_state
    t.string :name
    t.string :email
    t.timestamps
  end
end

unless ActiveRecord::Base.connection.table_exists?(:tests)
  ActiveRecord::Base.connection.create_table :tests do |t|
    t.references :patient, foreign_key: true
    t.references :doctor, foreign_key: true
    t.string :exam_result_token
    t.date :exam_date
    t.timestamps
  end
end

unless ActiveRecord::Base.connection.table_exists?(:exams)
  ActiveRecord::Base.connection.create_table :exams do |t|
    t.references :test, foreign_key: true
    t.string :exam_type
    t.string :exam_type_limits
    t.string :exam_type_result
    t.timestamps
  end
end

csv_file_path = File.expand_path('../data/data.csv', __dir__)

CSV.foreach(csv_file_path, col_sep: ';', headers: true) do |row|
  patient = Patient.find_or_create_by(cpf: row['cpf']) do |p|
    p.name = row['nome paciente']
    p.email = row['email paciente']
    p.birth_date = row['data nascimento paciente']
    p.street_address = row['endereço/rua paciente']
    p.city = row['cidade paciente']
    p.state = row['estado paciente']
  end

  doctor = Doctor.find_or_create_by(license_number: row['crm médico'], license_state: row['crm médico estado']) do |d|
    d.name = row['nome médico']
    d.email = row['email médico']
  end

  test = Test.create(
    patient: patient,
    doctor: doctor,
    exam_result_token: row['token resultado exame'],
    exam_date: row['data exame']
  )

  Exam.create(
    test: test,
    exam_type: row['tipo exame'],
    exam_type_limits: row['limites tipo exame'],
    exam_type_result: row['resultado tipo exame']
  )
end
