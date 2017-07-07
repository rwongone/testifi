require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe "User authentication", type: :request do
  describe "GET /api/users/oauth/google" do
    let(:name) { "Larry Learner" }
    let(:email) { "larry@downtolearn.com" }
    # code is a token that might come back from an auth service like google
    let(:code) { "ksf32hhkjhhhsf32434sfd" }
    # google_id is a permanent user id that might come back from google
    let(:google_id) { "328472342342" }

    it "returns a JWT and user info for a new user with a google_id" do
      validator = instance_double("GoogleIDToken::Validator")
      expect(GoogleIDToken::Validator).to receive(:new).and_return(validator)
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return({
          "sub"=>google_id,
          "name"=>name,
          "email"=>email
      })

      get("/api/users/oauth/google", params: {code: code})
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed['name']).to eq(name)
      expect(parsed['email']).to eq(email)
      expect(parsed['google_id']).to eq(google_id)
      expect(cookies['Authorization']).not_to be_empty
      expect(response).to have_http_status(200)
    end

    it "returns user info for an existing user with a google_id" do
      validator = instance_double("GoogleIDToken::Validator")
      expect(GoogleIDToken::Validator).to receive(:new).and_return(validator).exactly(2)
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return({
          "sub"=>google_id,
          "name"=>name,
          "email"=>email
      }).exactly(2)

      get("/api/users/oauth/google", params: {code: code})
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed['name']).to eq(name)
      expect(parsed['email']).to eq(email)
      expect(parsed['google_id']).to eq(google_id)
      expect(cookies['Authorization']).not_to be_empty
      expect(response).to have_http_status(200)

      first_id = parsed['id']

      get("/api/users/oauth/google", params: {code: code})
      parsed = ActiveSupport::JSON.decode(response.body)
      expect(parsed['name']).to eq(name)
      expect(parsed['email']).to eq(email)
      expect(parsed['google_id']).to eq(google_id)
      expect(parsed['id']).to eq(first_id)
      expect(response).to have_http_status(200)
    end

    it "returns a 403 for an invalid token" do
      validator = instance_double("GoogleIDToken::Validator")
      expect(GoogleIDToken::Validator).to receive(:new).and_return(validator)
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return(false)
      expect(validator).to receive(:problem).and_return("invalid token")

      get("/api/users/oauth/google", params: {code: code})
      expect(response).to have_http_status(403)
    end
  end

  def google_client
    OpenStruct.new Rails.application.secrets.google_client
  end
end
