require 'rails_helper'

RSpec.describe User, type: :model do

  let!(:user) { create(:user)}
  let!(:college) {user.colleges.create(name: Faker::University.name)}
  let!(:exam) { college.exams.create(name: 'math-test')}
  let!(:exam_window) {exam.create_exam_window(name: 'math-test-window', start_time: Time.now, end_time: Time.now + 3.hours)}

  it 'creates a new user' do
    expect(User.find_by_first_name(user.first_name)).to eq(user)
  end

  it 'can find the user' do
    expect(User.found?(*user.attributes.slice('first_name', 'last_name', 'phone_number'))).to be_truthy
  end

  it 'can detect non existing user' do
    expect(User.found?(*user.attributes.slice('first_name', 'last_name'), '123-456-7890')).to be_falsey
  end

  it 'can create a new user if not found' do
    first_name = 'John'
    last_name = 'Doe'
    phone_number = "1-123-456-7890"
    expect(User.found?(first_name, last_name, phone_number)).to be_falsey
    expect(User.create_if_not_found(first_name, last_name, phone_number)).to be_truthy
    expect(User.found?(first_name, last_name, phone_number)).to be_truthy
  end

  it 'can add an exam to user' do
    expect(user.exams).to be_empty
    user.add_exam(exam)
    expect(user.exams).not_to be_empty
    expect(user.exams.first).to eq(exam)
  end
end
