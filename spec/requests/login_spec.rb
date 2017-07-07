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

    # it "returns a 400 for an existing user with incorrect password" do
    #   post("/api/login", params: {email: email, password: "the_wrong_password"})
    #   expect(ActiveSupport::JSON.decode(response.body)).to eq({})
    #   expect(response).to have_http_status(400)
    # end

    # it "returns a 400 for a non-existent user" do
    #   post("/api/login", params: {email: "whatisthis", password: "doesn't matter"})
    #   expect(ActiveSupport::JSON.decode(response.body)).to eq({})
    #   expect(response).to have_http_status(400)
    # end
  end

  def google_client
    OpenStruct.new Rails.application.secrets.google_client
  end
end
