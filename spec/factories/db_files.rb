# frozen_string_literal: true

FactoryGirl.define do
  factory :submission_db_file, class: 'DbFile' do
    name 'Solution.java'
    contents "import java.util.*;\n\npublic static void main(String[] args) { System.out.println(3); }\n"
  end

  factory :test_db_file, class: 'DbFile' do
    name 'consec_5.in'
    contents "1 2 3 4 5\n"
  end

  factory :consec, class: 'DbFile' do
    transient do
      n 1
    end

    name { "consec_#{n}.in" }
    contents do
      (1..n).map(&:to_s).join(' ') + "\n"
    end
  end

  factory :fixture_db_file, class: 'DbFile' do
    transient do
      fixture_file nil
    end

    name { fixture_file&.original_filename || 'empty_file' }
    contents { fixture_file&.read || '' }
  end
end
