require 'pg'
require 'csv'

db_connection = PG.connect(
  host: 'db',
  user: 'postgres',
  password: 'password',
  dbname: 'rebase_labs'
)

db_connection.exec("
  CREATE TABLE IF NOT EXISTS patients (
    cpf VARCHAR(11) PRIMARY KEY,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    birth_date DATE NOT NULL,
    street_address VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    state VARCHAR NOT NULL
  )
")

db_connection.exec("
  CREATE TABLE IF NOT EXISTS doctors (
    license_number VARCHAR(10) PRIMARY KEY,
    license_state VARCHAR(2) NOT NULL,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL
  )
")

db_connection.exec("
  CREATE TABLE IF NOT EXISTS tests (
    id SERIAL PRIMARY KEY,
    patient_cpf VARCHAR(11) REFERENCES patients(cpf),
    doctor_license_number VARCHAR(10) REFERENCES doctors(license_number),
    exam_result_token VARCHAR(20),
    exam_date DATE NOT NULL
  )
")

db_connection.exec("
  CREATE TABLE IF NOT EXISTS exams (
    id SERIAL PRIMARY KEY,
    test_id INTEGER REFERENCES tests(id),
    exam_type VARCHAR NOT NULL,
    exam_type_limits VARCHAR NOT NULL,
    exam_type_result VARCHAR NOT NULL
  )
")

csv_file_path = File.expand_path('../data/data.csv', __dir__)

CSV.foreach(csv_file_path, col_sep: ';', headers: true) do |row|
  cpf = row['cpf'].gsub(/[\.\-]/, '')
  state = row['estado paciente'].nil? || row['estado paciente'].strip.empty? ? 'N/A' : row['estado paciente']

  db_connection.exec_params(
    "INSERT INTO patients (cpf, name, email, birth_date, street_address, city, state) 
     VALUES ($1, $2, $3, $4, $5, $6, $7)
     ON CONFLICT (cpf) DO NOTHING",
    [cpf, row['nome paciente'], row['email paciente'], row['data nascimento paciente'], row['endereço/rua paciente'], row['cidade paciente'], state]
  )

  db_connection.exec_params(
    "INSERT INTO doctors (license_number, license_state, name, email)
     VALUES ($1, $2, $3, $4)
     ON CONFLICT (license_number) DO NOTHING",
    [row['crm médico'], row['crm médico estado'], row['nome médico'], row['email médico']]
  )

  db_connection.exec_params(
    "INSERT INTO tests (patient_cpf, doctor_license_number, exam_result_token, exam_date)
     VALUES ($1, $2, $3, $4)
     RETURNING id",
    [cpf, row['crm médico'], row['token resultado exame'], row['data exame']]
  ) do |result|
    test_id = result[0]['id']

    db_connection.exec_params(
      "INSERT INTO exams (test_id, exam_type, exam_type_limits, exam_type_result)
       VALUES ($1, $2, $3, $4)",
      [test_id, row['tipo exame'], row['limites tipo exame'], row['resultado tipo exame']]
    )
  end
end

db_connection.close
