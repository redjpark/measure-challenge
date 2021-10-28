require 'rails_helper'

RSpec.describe "ExamSchedules", type: :request do

  let!(:user) { create(:user) }
  let!(:college) { create(:college) }
  let(:college_other) { create(:college) }
  let(:exam) { create(:exam, college: college) }
  let(:exam_other) { create(:exam, college: college_other) }

  let(:schedule_attributes) {
    user.attributes.slice('first_name', 'last_name', 'phone_number')
        .merge({ college_id: college.id })
        .merge({ exam_id: exam.id })
        .merge({ start_time: exam.exam_window.start_time + 10.minutes })
  }

  describe "POST /api/v1/schedule" do

    context "successful exam scheduling" do

      before do
        post "/api/v1/schedule", params: schedule_attributes
      end

      # it "schedules exam for user" do
      #   p user
      #   p college
      #   p exam
      #   p exam.exam_window
      #   p ">>> #{response.body} <<<"
      # end

      it "returns status code: 201" do
        expect(response).to have_http_status(:created)
      end

      it "returns exam details" do
        expect(json['first_name']).to eq(user.first_name)
        expect(json['last_name']).to eq(user.last_name)
        expect(json['phone_number']).to eq(user.phone_number)
        expect(json['college_id']).to eq(college.id)
        expect(json['exam_id']).to eq(exam.id)
        expect(json['start_time']).not_to be_empty
      end

      it "should persists" do
        get "/api/v1/schedule/#{user.id}"
        expect(json.size).to eq(1)
        expect(json.first['name']).to eq(exam.name)
        expect(json.first['college_id']).to eq(exam.college_id)
      end

      context "user is created if not already existing" do
        let(:new_schedule_attributes) {{
          first_name: 'John',
          last_name: "Adams-#{rand(10000)}",
          phone_number: Faker::PhoneNumber.cell_phone,
          college_id: college.id,
          exam_id: exam.id,
          start_time: exam.exam_window.start_time + 10.seconds
        }}

        it 'creates user and schedule' do
          # make sure user does not exist
          expect(User.find_by_last_name(new_schedule_attributes[:last_name])).to be_nil

          post '/api/v1/schedule', params: new_schedule_attributes

          # check the result
          expect(response).to have_http_status(:created)
          expect(json['last_name']).to eq(new_schedule_attributes[:last_name])

          #  check the user is created and persisted
          expect(User.find_by_last_name(new_schedule_attributes[:last_name])).not_to be_nil

        end
      end
    end

  end

  context "unsuccessful exam scheduling" do

    context "invalid request data: missing user info and start_time" do
      before do
        post '/api/v1/schedule',
             params: { college_id: college.id, exam_id: exam.id }
      end

      it "should return status code: 400" do
        expect(response).to have_http_status(:bad_request)
      end

      it "should return error message" do
        expect(json['message']).to match(/A bad request/i)
      end

    end

    context "given college is not in database" do
      before do
        post '/api/v1/schedule',
             params: schedule_attributes.merge({ college_id: 9999 })
      end

      it "should return status code: 404" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "given exam is not in the database" do
      before do
        post '/api/v1/schedule',
             params: schedule_attributes.merge({ exam_id: 7890 })
      end

      it "should return status code: 400" do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "given exam is not in the given college" do
      before do
        post '/api/v1/schedule',
             params: schedule_attributes.merge({ exam_id: exam_other.id })
      end

      it "should return status code: 400" do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "request start_time does not fall within the exam's time window" do
      before do
        post '/api/v1/schedule',
             params: schedule_attributes.merge(
               { start_time: exam.exam_window.start_time - 1.second })
      end

      it "should return status code: 400" do
        expect(response).to have_http_status(:bad_request)
      end
    end

  end
end
