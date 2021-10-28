require 'faker'

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone }
  end
  factory :college do
    name { Faker::University.name }
  end
  factory :exam do
    sequence(:name) { |n| "exam-#{n}" }
    after :create do |exam|
      create :exam_window, exam: exam
    end
  end

  factory :exam_window do
    sequence(:name) { |n| "exam-window-#{n}" }
    start_time { Time.now }
    end_time { Time.now + 3.hours }
  end

end