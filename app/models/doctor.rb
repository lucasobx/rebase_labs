class Doctor < ActiveRecord::Base
  has_many :tests
end
