class RegistrationMailer < ApplicationMailer
  default from: 'testifinoreply@gmail.com'

  def welcome_email(to, course, url)
    @course = course
    @teacher = course.teacher
    @url = url

    mail(to: to, subject: "Your Testifi Registration Link for #{course.title}")
  end
end
