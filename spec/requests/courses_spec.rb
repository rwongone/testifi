require 'helpers/rails_helper'

RSpec.describe "Courses", type: :request do
  include_context "with authenticated requests"
  let(:user) { create(:user) }
  let!(:course) { create(:course) }

  before do
    allow(Auth).to receive(:decode).and_return({ 'user_id' => user.id })
  end

  describe "GET /api/courses" do
    it "returns the Course as JSON" do
      get "/api/courses/#{course.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq(course.to_json)
    end
  end
end
