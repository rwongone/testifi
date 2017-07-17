namespace :db do
  desc "Populate the database with a course, assignment, problem and test. Run only after creating the first admin."
  task :populate => :environment do
    c = Course.create!({
      course_code: "ICS3U",
      title: "Introduction to Computer Science, Grade 11 University Preparation",
      description: "This course introduces students to computer science. Students will design software independently and as part of a team, using industry-standard programming tools and applying the software development life-cycle model. They will also write and use subprograms within computer programs. Students will develop creative solutions for various types of problems as their understanding of the computing environment grows.  They will also explore environmental and ergonomic issues, emerging research in computer science, and global career trends in computer-related fields.",
      teacher_id: 1
    })
    a = Assignment.create!({
      name: "Assignment 0",
      description: "Test your setup and familiarize yourself with how to submit a solution.",
      course_id: c.id,
    })
    p = Problem.create!({
      name: "From Humble Beginnings",
      description: "Write a Java class whose main method prints the string 'Hello World!' to the standard output stream (i.e. System.out).",
      assignment_id: a.id,
    })
    f = DbFile.create!(
      name: "empty.txt",
      content_type: "txt",
      contents: "",
    )
    t = Test.create!({
      name: "No Input",
      hint: nil,
      problem_id: p.id,
      user_id: 1,
      db_file_id: f.id,
    })
  end
end
