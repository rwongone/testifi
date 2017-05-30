FactoryGirl.define do
  factory :problem do
    name { "Counting Inversions" }
    description { "Count the inversions in the array provided." }
    cmd { "g++ submission/submitted_file.cpp && ./a.out < input/sample_test > output/program_output" }
  end
end
