# frozen_string_literal: true

namespace :db do
  desc 'Populate the database with a course, assignment, problem and test. Run only after creating the first admin.'
  task populate: :environment do
    u = User.find(1)
    c = Course.create!(
      course_code: 'ICS3U',
      title: 'Introduction to Computer Science, Grade 11 University Preparation',
      description: 'This course introduces students to computer science. Students will design software independently and as part of a team, using industry-standard programming tools and applying the software development life-cycle model. They will also write and use subprograms within computer programs. Students will develop creative solutions for various types of problems as their understanding of the computing environment grows.  They will also explore environmental and ergonomic issues, emerging research in computer science, and global career trends in computer-related fields.',
      teacher: u
    )
    a = Assignment.create!(
      name: 'Assignment 0',
      description: 'Test your setup and familiarize yourself with how to submit a solution.',
      course: c
    )
    p = Problem.create!(
      name: 'From Humble Beginnings',
      description: "Write a Java class whose main method prints the string 'Hello World!' to the standard output stream (i.e. System.out).",
      assignment: a
    )
    f = DbFile.create!(
      name: 'empty.txt',
      content_type: 'txt',
      contents: ''
    )
    t = Test.create!(
      name: 'No Input',
      hint: nil,
      problem: p,
      user: u,
      db_file_id: f.id
    )
    s_f = DbFile.create!(
      name: 'Solution.java',
      content_type: 'java',
      contents: 'public class Solution { public static void main(String[] args) { System.out.println("Hello, world!"); } }'
    )
    s = Submission.create!(
      user: u,
      problem: p,
      language: 'java',
      db_file_id: s_f.id
    )
    p.update(solution_id: s.id)

    p2 = Problem.create!(
      name: 'Putting the Pieces Together',
      description: 'Write a Java class that prints the concatenation of space-separated strings provided via the standard input stream.',
      assignment: a
    )
    f2 = DbFile.create!(
      name: 'abcdefg',
      content_type: 'txt',
      contents: 'a b c d e f g'
    )
    t2 = Test.create!(
      name: 'letters',
      hint: nil,
      problem: p2,
      user: u,
      db_file_id: f2.id
    )
    f3 = DbFile.create!(
      name: '0xdeadbeef',
      content_type: 'txt',
      contents: '0x dead beef'
    )
    t3 = Test.create!(
      name: 'hexcode',
      hint: nil,
      problem: p2,
      user: u,
      db_file_id: f3.id
    )
    s_f2 = DbFile.create!(
      name: 'Solution.java',
      content_type: 'java',
      contents: File.open('spec/fixtures/files/Concat.java', 'r').read
    )
    s2 = Submission.create!(
      user: u,
      problem: p2,
      language: 'java',
      db_file_id: s_f2.id
    )
    p2.update(solution_id: s2.id)

    FillExpectedOutputJob.new.perform(t.id, t2.id, t3.id)
  end
end
