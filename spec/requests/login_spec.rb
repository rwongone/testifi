# frozen_string_literal: true

require 'helpers/api_helper'
require 'helpers/rails_helper'

RSpec.describe 'User authentication', type: :request do
  include_context 'with JSON responses'

  describe 'GET /api/users/oauth/google' do
    let(:name) { 'Larry Learner' }
    let(:email) { 'larry@downtolearn.com' }
    # code is a token that might come back from an auth service like google
    let(:code) { 'google_auth_token_123' }
    let(:second_code) { 'google_auth_token_125' }
    # google_id is a permanent user id that might come back from google
    let(:google_id) { 'google_id_123' }
    let(:second_google_id) { 'google_id_125' }
    let(:g_validator_response) do
      {
        sub: google_id,
        name: name,
        email: email
      }.with_indifferent_access
    end
    let(:g_validator_response_2) do
      {
        sub: second_google_id,
        name: 'Some random name',
        email: 'email@example.com'
      }.with_indifferent_access
    end
    let(:expected_response) do
      {
        google_id: google_id,
        name: name,
        email: email
      }
    end
    let(:validator) { instance_double('GoogleIDToken::Validator') }

    before do
      allow(GoogleIDToken::Validator).to receive(:new).and_return(validator)
    end

    it 'returns a JWT and user info for a new user with a google_id' do
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return(g_validator_response)

      get('/api/users/oauth/google', params: { code: code })
      expect(response).to have_http_status(200)
      expect(json_response).to include(expected_response)
      expect(cookies['Authorization']).not_to be_empty
    end

    it 'returns user info for an existing user with a google_id' do
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return(g_validator_response).twice

      get('/api/users/oauth/google', params: { code: code })
      expect(response).to have_http_status(200)
      expect(json_response).to include(expected_response)
      expect(cookies['Authorization']).not_to be_empty

      first_id = json_response['id']

      get('/api/users/oauth/google', params: { code: code })
      expect(response).to have_http_status(200)
      expect(json_response).to include(expected_response)
      expect(json_response['id']).to eq(first_id)
    end

    it 'returns a 403 for an invalid token' do
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return(false)
      expect(validator).to receive(:problem).and_return('invalid token')

      get('/api/users/oauth/google', params: { code: code })
      expect(response).to be_forbidden
    end

    it 'makes the first user in the system an admin' do
      expect(User.count).to eq(0)
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return(g_validator_response)

      get('/api/users/oauth/google', params: { code: code })
      expect(response).to have_http_status(200)
      expect(json_response['admin']).to eq(true)
    end

    it 'does not make any subsequent users admin' do
      # create first user as admin
      create(:teacher)

      # create second user
      expect(validator).to receive(:check).with(second_code, google_client.id, google_client.id).and_return(g_validator_response_2)
      get('/api/users/oauth/google', params: { code: second_code })
      expect(response).to have_http_status(200)
      expect(json_response['admin']).to eq(false)
    end
  end

  describe 'GET /api/logout' do
    it 'resets the auth cookie' do
      get('/api/logout')
      expect(cookies['Authorization']).to be_nil
      expect(response).to be_ok
    end
  end

  def google_client
    OpenStruct.new Rails.application.secrets.google_client
  end
end
