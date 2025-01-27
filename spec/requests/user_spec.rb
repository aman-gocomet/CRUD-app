require 'rails_helper'

RSpec.describe Api::User::RegistrationController, type: :request do
  describe "GET /api/user/get_users" do
    before do
      create_list(:user, 3) # Using FactoryBot to create 3 test users
    end

    it "fetches all users" do
      get '/api/user/get_users'

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(3)

      json_response.each_with_index do |user, index|
        expect(user["email"]).to eq("user#{index + 1}@example.com")
        expect(user["name"]).to eq("User#{index + 1}")
      end
    end
  end

  describe "POST /api/user/sign_up" do
    let(:valid_params) do
      {
        email: "aman.singh1232@gmail.com",
        name: "Aman Singh",
        password: "Password",
        password_confirmation: "Password"
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        post '/api/user/sign_up', params: valid_params

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(json_response["user"]["email"]).to eq(valid_params[:email])
        expect(json_response["user"]["name"]).to eq(valid_params[:name])
      end
    end

    context "when the email is already taken" do
      before { create(:user, email: valid_params[:email]) }

      it "returns an error" do
        post '/api/user/sign_up', params: valid_params

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Email has already been taken")
      end
    end

    context "with invalid parameters" do
      it "returns an error if the email is invalid" do
        invalid_params = valid_params.merge(email: "invalid_email")
        post '/api/user/sign_up', params: invalid_params

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Email is invalid")
      end

      it "returns an error if the password confirmation does not match" do
        invalid_params = valid_params.merge(password_confirmation: "WrongPassword")
        post '/api/user/sign_up', params: invalid_params

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
