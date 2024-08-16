class SchemaSetup
  def self.create_tables
    conn = DBConnection.connection
    
    conn.exec("
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

    conn.exec("
      CREATE TABLE IF NOT EXISTS doctors (
        license_number VARCHAR(10) PRIMARY KEY,
        license_state VARCHAR(2) NOT NULL,
        name VARCHAR NOT NULL,
        email VARCHAR NOT NULL
      )
    ")

    conn.exec("
      CREATE TABLE IF NOT EXISTS tests (
        id SERIAL PRIMARY KEY,
        patient_cpf VARCHAR(11) REFERENCES patients(cpf),
        doctor_license_number VARCHAR(10) REFERENCES doctors(license_number),
        exam_result_token VARCHAR(20),
        exam_date DATE NOT NULL
      )
    ")

    conn.exec("
      CREATE TABLE IF NOT EXISTS exams (
        id SERIAL PRIMARY KEY,
        test_id INTEGER REFERENCES tests(id),
        exam_type VARCHAR NOT NULL,
        exam_type_limits VARCHAR NOT NULL,
        exam_type_result VARCHAR NOT NULL
      )
    ")

    conn.close
  end
end
