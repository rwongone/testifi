# frozen_string_literal: true

require 'helpers/rails_helper'

RSpec.describe OnboardingMailer, type: :mailer do
  let(:teacher) { create(:teacher) }
  let(:student_email) { 'sendhere@example.com' }
  let(:student) { create(:student, email: student_email) }
  let(:course_title) { 'Introduction to Testing' }
  let(:course) { create(:course, teacher: teacher, students: [student], title: course_title) }
  let(:invite) { create(:invite, email: student.email, inviter: teacher, course: course) }
  let(:url) { 'https://www.google.com' }

  describe '#welcome_email' do
    subject { described_class.welcome_email(invite) }

    it 'renders the appropriate headers' do
      expect(subject).to have_attributes(from: [OnboardingMailer.default[:from]],
                                         to: [student_email],
                                         subject: "Your Testifi Registration Link for #{course_title}")
    end

    it 'renders the body' do
      expect(subject.html_part.body.to_s).to include(invite.url)
      expect(subject.html_part.body.to_s).to include(course.title)
      expect(subject.html_part.body.to_s).to include(teacher.name)
      expect(subject.text_part.body.to_s).to include(invite.url)
      expect(subject.text_part.body.to_s).to include(course.title)
      expect(subject.text_part.body.to_s).to include(teacher.name)
    end

    it 'delivers a welcome email' do
      expect do
        perform_enqueued_jobs { subject.deliver_later }
      end.to change { ActionMailer::Base.deliveries.size }.by(2)
    end
  end
end
