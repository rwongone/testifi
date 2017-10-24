# frozen_string_literal: true

FactoryGirl.define do
  factory :submission do
    transient do
      file nil
    end

    db_file_id { create(:fixture_db_file, fixture_file: file).id }
    language { FileHelper.filename_to_language(file.original_filename) }
  end
end
