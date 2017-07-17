require 'helpers/rails_helper'
require 'helpers/api_helper'

RSpec.describe "Invites", type: :request do
  include ActiveJob::TestHelper
  include_context "with authenticated requests"
  include_context "with JSON responses"

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let!(:invite) { create(:invite, course: course, inviter: teacher, email: student.email) }
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
      let(:mail) { double("Mail::Message") }

      subject { post "/api/courses/#{course.id}/invites", params: params }

      it "creates an invite" do
        subject
        expect(response).to be_created
        expect(json_response.size).to eq(1)
        expect(json_response.first).to include(invite_properties)
      end

      it "creates a Job to send a welcome email" do
        expect { subject }.to have_enqueued_job.on_queue('mailers')
      end

      it "delivers a welcome email" do
        expect(OnboardingMailer).to receive(:welcome_email).and_return(mail)
        expect(mail).to receive(:deliver_later)

        subject
      end
    end

    describe "POST /api/invites/:id/resend" do
      let(:mail) { double("Mail::Message") }

      subject { post "/api/invites/#{invite.id}/resend" }

      it "sends a message" do
        expect(OnboardingMailer).to receive(:welcome_email).and_return(mail)
        expect(mail).to receive(:deliver_later)

        subject
        expect(response).to be_no_content
      end

      it "404s when the invite has been claimed" do
        invite.update(redeemer: student)
        subject
        expect(response).to be_not_found
      end
    end

    describe "GET /api/courses/:id/invites/unused" do
      it "returns invites that have not been redeemed" do
        get "/api/courses/#{course.id}/invites/unused"
        expect(response).to be_ok
        expect(json_response.size).to eq(1)
        expect(json_response.first).to include(invite_properties)
      end

      it "does not return invites that have been redeemed" do
        invite.update(redeemer: student)
        get "/api/courses/#{course.id}/invites/unused"
        expect(response).to be_ok
        expect(json_response).to be_empty
      end
    end
  end

  context "when a student is authenticated" do
    before { authenticate(student) }

    describe "GET /api/invites/:id/redeem" do
      it "redeems the invite successfully" do
        get "/api/invites/#{invite.id}/redeem"
        expect(response).to be_ok
        expect(json_response).to include(invite_properties.merge({
          "redeemer_id" => student.id
        }))
        expect(student.enrolled_courses.size).to eq(1)
        expect(student.enrolled_courses.first).to eq(course)
      end

      it "rejects invalid invite ids" do
        get "/api/invites/INVALID_INVITE_UUID/redeem"
        expect(response).to be_forbidden
      end

      it "rejects used invites" do
        old_redeemer = create(:student)
        invite.update(redeemer: old_redeemer)

        get "/api/invites/#{invite.id}/redeem"
        expect(response).to be_forbidden
      end
    end

    describe "POST /api/courses/:id/invites" do
      let(:params) { default_params }

      it "is inaccessible" do
        post "/api/courses/#{course.id}/invites"
        expect(response).to be_forbidden
      end
    end

    describe "POST /api/invites/:id/resend" do
      subject { post "/api/invites/#{invite.id}/resend" }

      it "is inaccessible" do
        subject
        expect(response).to be_forbidden
      end
    end

    describe "GET /api/courses/:id/invites/unused" do
      it "is inaccessible" do
        get "/api/courses/#{course.id}/invites/unused"
        expect(response).to be_forbidden
      end
    end
  end
end
