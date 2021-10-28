class Exam < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :college
  has_one :exam_window
  validates_presence_of :college_id

  def valid_window?(start_time)
    parsed_start_time = DateTime.parse(start_time)
    exam_start_time = self.exam_window.start_time.to_i
    exam_end_time = self.exam_window.end_time.to_i
    request_start_time = parsed_start_time.to_i
    exam_start_time <= request_start_time && request_start_time <= exam_end_time
  end
end
