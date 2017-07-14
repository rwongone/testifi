class InvitesController < ApplicationController
  skip_before_action :check_admin, only: [:redeem]

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

  def redeem
    invite_id = params[:invite_id]
    begin
      invite = Invite.find(invite_id)
    rescue ActiveRecord::RecordNotFound
      head :forbidden
      return
    end
    invite.redeemer = current_user
    invite.save!
    invite.course.students << current_user
    render status: :ok, json: invite
  end
end
