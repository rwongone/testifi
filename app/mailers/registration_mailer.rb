class RegistrationMailer < ApplicationMailer
  default from: 'testifinoreply@gmail.com'

  def welcome_email(invite, url)
    to = invite.email
    @course = invite.course
    @inviter = invite.inviter
    @url = url

    mail(to: to, subject: "Your Testifi Registration Link for #{@course.title}")
  end
end
