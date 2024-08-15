class Patient < ActiveRecord::Base
  has_many :tests
  has_many :exams, through: :tests
end