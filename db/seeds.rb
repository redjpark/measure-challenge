# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
#
require 'faker'

ExamWindow.delete_all
Exam.delete_all
User.delete_all
College.delete_all

(0...5).each do |n|
  user = User.create(first_name: "first#{n}",
                     last_name: "last#{n}",
                     phone_number: Faker::PhoneNumber.cell_phone)
  college = user.colleges.create(name: "college#{n}")
  (0...3).each do |j|
    exam = college.exams.create(name: "exam-#{j}-college-#{n}")
    user.exams << exam
    # p exam
    ew = exam.create_exam_window(name: "window-#{j}-exam-#{j}",
                                 start_time: Time.now + j.hours,
                                 end_time: Time.now + (j+3).hours)
    # p ew
  end
end

p "User# #{User.count}"
p "College# #{College.count}"
p "Exam# #{Exam.count}"
p "ExamWindow# #{ExamWindow.count}"


