class InvitesController < ApplicationController
  def create
    course_id = params[:course_id]
    emails = params[:emails]
    current_user_id = current_user.id
    invites = []
    url = "https://www.placeholder.com"

    ActiveRecord::Base.transaction do
      invites = emails.map do |email|
        invite = Invite.create({
          "course_id" => course_id,
          "email" => email,
          "inviter_id" => current_user_id
        })
        OnboardingMailer.welcome_email(invite, url).deliver_later
        invite
      end
    end
    render status: :created, json: invites
  end
end
