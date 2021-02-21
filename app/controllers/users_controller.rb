class UsersController < ApplicationController
  # link in members#index
  def resend_invitation
    # This logic is not in membres_controller, because it does not require any member-specific data to work.
    @user = User.find(params[:id])
    if @user.invitation_accepted_at.present?
      redirect_to members_path, alert: "User with email #{@user.email} has already accepted the invitation"
    else
      @user.invite!
      redirect_to members_path, notice: "Invitation resent to #{@user.email}"
    end
  end

  def show
    @user = if current_user.superadmin?
      User.friendly.find(params[:id])
    else
      current_user
    end
    # see your invitations
    @invited_users = User.where(invited_by_id: @user.id)
  end
end
