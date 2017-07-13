class InvitesController < ApplicationController
  def create
    course_id = params[:course_id]
    emails = params[:emails]
    current_user_id = current_user.id
    invites = []
    ActiveRecord::Base.transaction do
      emails.each { |e|
        invite = Invite.create({
          "course_id" => course_id,
          "email" => e,
          "inviter_id" => current_user_id
        })
        invite.save!
        invites << invite
      }
    end
    render status: :created, json: invites
  end
end
