# frozen_string_literal: true

class InvitesController < ApplicationController
  skip_before_action :check_admin, only: [:redeem]

  def create
    course_id = params[:course_id]
    emails = params[:emails]
    current_user_id = current_user.id
    invites = []

    ActiveRecord::Base.transaction do
      invites = emails.map do |email|
        invite = Invite.create('course_id' => course_id,
                               'email' => email,
                               'inviter_id' => current_user_id)
        OnboardingMailer.welcome_email(invite).deliver_later
        invite
      end
    end
    render status: :created, json: invites
  end

  def resend
    invite_id = params[:invite_id]
    invite = Invite.find_by(id: invite_id, redeemer_id: nil)
    if invite.nil?
      head :not_found
      return
    end
    OnboardingMailer.welcome_email(invite).deliver_later
    head :no_content
  end

  def redeem
    invite_id = params[:invite_id]
    invite = Invite.find_by(id: invite_id, redeemer_id: nil)
    if invite.nil?
      head :forbidden
      return
    end
    invite.redeemer_id = current_user.id
    invite.save!
    invite.course.students << current_user
    render status: :ok, json: invite
  end

  def unused
    course_id = params[:course_id]
    invites = Invite.unused.where(course_id: course_id)
    render status: :ok, json: invites
  end
end
