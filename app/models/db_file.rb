class DbFile < ApplicationRecord
  belongs_to :has_a_file, polymorphic: true
end
