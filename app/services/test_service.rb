class TestService
  def self.fetch_all_tests
    Test.includes(:patient, :doctor, :exams).map do |test|
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
    end
  end
end
