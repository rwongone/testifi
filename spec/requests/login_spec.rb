require 'rails_helper'

RSpec.describe "User authentication", type: :request do
  describe "POST /api/login" do
    let(:name) { "Larry Learner" }
    let(:email) { "larry@downtolearn.com" }
    let(:password) { "test_password" }
    let!(:user) { User.create!(name: name, email: email, password: password, password_confirmation: password) }

    it "returns a JWT for an existing user with the correct password" do
      post("/api/login", params: {email: email, password: password})
      expect(ActiveSupport::JSON.decode(response.body)).to have_key('jwt')
      expect(response).to have_http_status(200)
    end

    it "returns a 400 for an existing user with incorrect password" do
      post("/api/login", params: {email: email, password: "the_wrong_password"})
      expect(ActiveSupport::JSON.decode(response.body)).to eq({})
      expect(response).to have_http_status(400)
    end

    it "returns a 400 for a non-existent user" do
      post("/api/login", params: {email: "whatisthis", password: "doesn't matter"})
      expect(ActiveSupport::JSON.decode(response.body)).to eq({})
      expect(response).to have_http_status(400)
    end
  end
end
