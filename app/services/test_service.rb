require 'pg'

class TestService
  def self.fetch_all_tests
    db_connection = PG.connect(
      host: 'db',
      user: 'postgres',
      password: 'password',
      dbname: 'rebase_labs'
    )

    results = db_connection.exec("
      SELECT tests.id AS test_id, tests.exam_result_token, tests.exam_date, patients.cpf, patients.name, patients.email, patients.birth_date,
             doctors.license_number, doctors.license_state, doctors.name AS doctor_name, doctors.email AS doctor_email
      FROM tests
      JOIN patients ON tests.patient_cpf = patients.cpf
      JOIN doctors ON tests.doctor_license_number = doctors.license_number
    ")

    tests = results.map do |row|
      {
        result_token: row['exam_result_token'],
        result_date: row['exam_date'],
        patient: {
          cpf: row['cpf'],
          name: row['name'],
          email: row['email'],
          birth_date: row['birth_date']
        },
        doctor: {
          crm: row['license_number'],
          crm_state: row['license_state'],
          name: row['doctor_name'],
          email: row['doctor_email']
        },
        exams: fetch_exams_for_test(db_connection, row['test_id'])
      }
    end

    db_connection.close
    tests
  end

  def self.fetch_exams_for_test(db_connection, test_id)
    exams = db_connection.exec_params("SELECT exam_type, exam_type_limits, exam_type_result FROM exams WHERE test_id = $1", [test_id])
    exams.map do |exam|
      {
        type: exam['exam_type'],
        limits: exam['exam_type_limits'],
        result: exam['exam_type_result']
      }
    end
  end
end

