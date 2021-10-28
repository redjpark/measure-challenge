require 'rails_helper'

RSpec.describe "Colleges", type: :request do

  let!(:colleges) { create_list(:college, 5) }
  let(:college_id) { colleges.first.id }

  describe "GET /api/v1/colleges" do
    before do
      get '/api/v1/colleges'
    end

    it 'returns college list' do
      # p colleges
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(5)
    end

  end

  describe "GET /api/v1/colleges/:id" do
    before do
      get "/api/v1/colleges/#{college_id}"
      # p json
    end

    context "existing college" do
      it "returns the college" do
        expect(response).to have_http_status(:ok)
        expect(json).not_to be_empty
        expect(json['id']).to eq(college_id)
      end
    end
  end

  describe 'POST /api/v1/colleges' do
    let(:college_attributes) { {
      name: Faker::University.name
    } }

    context "with valid college attributes" do
      before do
        post '/api/v1/colleges', params: college_attributes
      end

      it "creates a new college" do
        expect(json['name']).to eq(college_attributes[:name])
      end

      it "returns status code: 201" do
        expect(response).to have_http_status(:created)
      end
    end
  end

end
