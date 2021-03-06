# frozen_string_literal: true

class Invite < ApplicationRecord
  belongs_to :inviter, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :course
  belongs_to :redeemer, class_name: 'User', foreign_key: 'redeemer_id', optional: true

  after_create_commit :send_email

  def self.unused
    where(redeemer_id: nil)
  end

  def url
    Rails.configuration.url + '/redeem/' + id
  end

  def send_email
    OnboardingMailer.welcome_email(self).deliver_later
  end
end
