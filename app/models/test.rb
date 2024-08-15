class Test < ActiveRecord::Base
  belongs_to :patient
  belongs_to :doctor
  has_many :exams
end
