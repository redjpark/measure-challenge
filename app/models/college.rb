class College < ApplicationRecord
  has_many :exams
  has_and_belongs_to_many :users

  def valid_exam?(exam_id)
    self.exams.pluck(:id).include?(exam_id.to_i)
  end
end
