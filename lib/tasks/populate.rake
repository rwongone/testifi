namespace :db do
  desc "Populate the database with a course, assignment, problem and test"
  task :populate => :environment do
    c = Course.create({
      "course_code" => "JAVA101",
      "title" => "Introduction to Java",
      "description" => "This course introduces students to Java",
      "teacher_id" => 1
    })
    c.save!
    u = User.find(2)
    c.students << u
    a = Assignment.create({
      "name" => "Assignment 1",
      "description" => "This assignment introduces students to printing stuff",
      "course_id" => 1
    })
    a.save!
    p = Problem.create({
      "name" => "Problem 1",
      "description" => "Print out the string 'Hello world!'",
      "assignment_id" => 1
    })
    p.save!
    f = DbFile.create(
      "name" => "test_1_input.txt",
      "content_type" => "txt",
      "contents" => ""
    )
    f.save!
    t = Test.create({
      "name" => "Test 1",
      "hint" => nil,
      "problem_id" => 1,
      "user_id" => 1,
      "db_file_id" => 1
    })
  end
end
