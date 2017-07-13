require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe "Invites", type: :request do
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let!(:invite) { create(:invite) }
  let(:default_params) do
    {
      "emails" => [student.email]
    }
  end
  let(:invite_properties) do
    {
      "course_id" => course.id,
      "inviter_id" => teacher.id,
      "email" => student.email,
    }
  end

  context "when a teacher is authenticated" do
    before { authenticate(teacher) }

    describe "POST /api/courses/:id/invites" do
      let(:params) { default_params }

      it "creates an invite" do
        post "/api/courses/#{course.id}/invites", params: params
        expect(response).to have_http_status(201)
        expect(json_response.size).to eq(1)
        expect(json_response.first).to include(invite_properties)
      end
    end
  end

  context "when a student is authenticated" do
    before { authenticate(student) }

    describe "POST /api/courses/:id/invites" do
      let(:params) { default_params }

      it "is inaccessible" do
        post "/api/courses/#{course.id}/invites"
        expect(response).to be_forbidden
      end
    end
  end
end
