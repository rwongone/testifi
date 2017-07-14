class Invite < ApplicationRecord
  belongs_to :inviter, class_name: "User", foreign_key: "inviter_id"
  belongs_to :course
  belongs_to :redeemer, class_name: "User", foreign_key: "redeemer_id", optional: true
end