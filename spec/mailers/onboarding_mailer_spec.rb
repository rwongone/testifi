require "helpers/rails_helper"

RSpec.describe OnboardingMailer, type: :mailer do
  let(:teacher) { create(:teacher) }
  let(:student_email) { "sendhere@example.com" }
  let(:student) { create(:student, email: student_email) }
  let(:course_title) { "Introduction to Testing" }
  let(:course) { create(:course, teacher: teacher, students: [student], title: course_title) }
  let(:invite) { create(:invite, email: student.email, inviter: teacher, course: course) }
  let(:url) { "https://www.google.com" }

  describe "#welcome_email" do
    subject { described_class.welcome_email(invite, url) }

    it 'renders the appropriate headers' do
      expect(subject).to have_attributes({
        from: [OnboardingMailer.default[:from]],
        to: [student_email],
        subject: "Your Testifi Registration Link for #{course_title}",
      })
    end

    it 'renders the body' do
      expect(subject.html_part.body.to_s).to eq(file_fixture("welcome_email.html").read)
      expect(subject.text_part.body.to_s).to eq(file_fixture("welcome_email.txt").read)
    end

    it 'delivers a welcome email' do
      expect {
        perform_enqueued_jobs { subject.deliver_later }
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end
end
