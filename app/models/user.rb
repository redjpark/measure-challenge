class User < ApplicationRecord
  has_and_belongs_to_many :exams
  has_and_belongs_to_many :colleges

  validates_presence_of :first_name, :last_name, :phone_number

  def self.found?(first_name, last_name, phone_number)
    User.find_by(first_name: first_name, last_name: last_name, phone_number: phone_number)
  end

  def self.create_if_not_found(first_name, last_name, phone_number)
    return self.found?(first_name, last_name, phone_number) ||
      User.create(first_name: first_name, last_name: last_name, phone_number: phone_number)
  end

  def add_exam(exam)
    self.exams << exam
  end

end
