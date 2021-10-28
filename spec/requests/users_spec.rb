require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:users) { create_list(:user, 5)}
  let(:user_id) { users.first.id}

  describe "GET /api/v1/users" do
    before do
      get '/api/v1/users'
    end

    it 'returns user list' do
      # p users
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(5)
    end

  end

  describe "GET /api/v1/users/:id" do
    before do
      get "/api/v1/users/#{user_id}"
      # p json
    end

    context "existing user" do
      it "returns the user" do
        expect(response).to have_http_status(:ok)
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end
    end

    context "non existing user" do
      let(:user_id) { 99999 }

      it "returns 404" do
        expect(response).to have_http_status(404)
      end

      it "return a record not found error message" do
        expect(json['message']).to match(/Couldn't find User with/)
      end
    end
  end

  describe 'POST /api/v1/users' do
    let(:user_attributes) { {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      phone_number: Faker::PhoneNumber.cell_phone
    }}

    let(:invalid_user_attributes) { {
      # first_name: Faker::Name.first_name,
      # last_name: Faker::Name.last_name,
      phone_number: Faker::PhoneNumber.cell_phone
    }}

    context "with valid user attributes" do
      before do
        post '/api/v1/users', params: user_attributes
      end

      it "creates a new user" do
        expect(json['first_name']).to eq(user_attributes[:first_name])
      end

      it "returns status code: 201" do
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid user attributes" do
      before do
        post '/api/v1/users', params: invalid_user_attributes
        # p response.body
      end

      it "returns status code: 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error message" do
        expect(json['message']).to match(/Validation failed: First name can't be blank, Last name can't be blank/)
      end
    end
  end

  describe "PUT /api/v1/users/:id" do
    let(:update_attributes) {{first_name: "joe-#{rand(100)}"}}

    context "update existing user" do
      before do
        put "/api/v1/users/#{user_id}", params: update_attributes
      end

      it "updates the user attribute" do
        expect(response.body).to be_empty
      end

      it "returns status code: 204" do
        expect(response).to have_http_status(:no_content)
      end
    end

    context "updating non existing user" do
      before do
        put "/api/v1/users/99999", params: update_attributes
      end

      it "returns status code: 404" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns appropriate error message" do
        expect(json['message']).to match(/Couldn't find User with/i)
      end
    end

  end

  describe "DELETE /api/v1/users/:id" do
    before do
      delete "/api/v1/users/#{user_id}"
    end

    context "deleting existing user" do
      it "returns status code: 204" do
        expect(response).to have_http_status(:no_content)
      end

      it "removes the user" do
        get "/api/v1/users/#{user_id}"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "delete non existing user" do
      let(:user_id) {9999}

      it "returns status code: 404" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns error message" do
        expect(json['message']).to match(/Couldn't find User with/)
      end
    end
  end
end
