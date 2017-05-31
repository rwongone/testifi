require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let(:user) { create(:user) }
  let!(:course) { create(:course) }
  let(:headers) { {} }
  let(:auth_header) { {'HTTP_AUTHORIZATION': 'Bearer X'} }

  before do
    allow(Auth).to receive(:decode).and_return({ 'user_id' => user.id })
  end

  describe "GET /courses" do
    it "returns the Course as JSON" do
      get "/courses/#{course.id}", headers: headers.merge(auth_header)
      expect(response).to have_http_status(200)
      expect(response.body).to eq(course.to_json)
    end
  end
end
