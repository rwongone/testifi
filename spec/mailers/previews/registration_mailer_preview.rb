# Preview all emails at http://localhost:3000/rails/mailers/registration_mailer
class RegistrationMailerPreview < ActionMailer::Preview
  def welcome_email
    teacher = User.new({
      id: 1,
      name: "Teacher X",
      email: "testifinoreply@gmail.com",
      admin: true
    })
    student = User.new({
      id: 2,
      name: "Student Y",
      email: "anemail@example.com",
      admin: false
    })
    course = Course.new({
      id: 1,
      course_code: "JAVA101",
      title: "Introduction to Java",
      description: "This course introduces students to Java",
      teacher: teacher
    })
    url = "http://www.google.com"
    RegistrationMailer.welcome_email(student.email, course, url)
  end
end
