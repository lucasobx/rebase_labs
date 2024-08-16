require 'csv'

class Importer
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
  end

  def import_data
    conn = DBConnection.connection

    CSV.foreach(@csv_file_path, col_sep: ';', headers: true) do |row|
      cpf = row['cpf'].gsub(/[\.\-]/, '')
      state = row['estado paciente'].nil? || row['estado paciente'].strip.empty? ? 'N/A' : row['estado paciente']

      conn.exec_params(
        "INSERT INTO patients (cpf, name, email, birth_date, street_address, city, state) 
         VALUES ($1, $2, $3, $4, $5, $6, $7)
         ON CONFLICT (cpf) DO NOTHING",
        [cpf, row['nome paciente'], row['email paciente'], row['data nascimento paciente'], row['endereço/rua paciente'], row['cidade paciente'], state]
      )

      conn.exec_params(
        "INSERT INTO doctors (license_number, license_state, name, email)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (license_number) DO NOTHING",
        [row['crm médico'], row['crm médico estado'], row['nome médico'], row['email médico']]
      )

      conn.exec_params(
        "INSERT INTO tests (patient_cpf, doctor_license_number, exam_result_token, exam_date)
         VALUES ($1, $2, $3, $4)
         RETURNING id",
        [cpf, row['crm médico'], row['token resultado exame'], row['data exame']]
      ) do |result|
        test_id = result[0]['id']

        conn.exec_params(
          "INSERT INTO exams (test_id, exam_type, exam_type_limits, exam_type_result)
           VALUES ($1, $2, $3, $4)",
          [test_id, row['tipo exame'], row['limites tipo exame'], row['resultado tipo exame']]
        )
      end
    end

    conn.close
  end
end
