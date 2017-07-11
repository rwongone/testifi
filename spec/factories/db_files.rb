FactoryGirl.define do
  factory :submission_db_file, class: "DbFile" do
    name "Solution.java"
    contents "import java.util.*;\n\npublic static void main(String[] args) { System.out.println(3); }\n"
  end

  factory :test_db_file, class: "DbFile" do
    name "consec_5.in"
    contents "1 2 3 4 5\n"
  end
end
