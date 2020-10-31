class UsersController < ApplicationController
  
  def resend_invitation #link in members#index
    #This logic is not in membres_controller, because it does not require any member-specific data to work.
    @user = User.find(params[:id])
    if @user.invitation_accepted_at.present?
      redirect_to members_path, alert: "User with email #{@user.email} has already accepted the invitation"
    else
      @user.invite!
      redirect_to members_path, notice: "Invitation resent to #{@user.email}"
    end
  end
  
  def show
    if current_user.superadmin?
      @user = User.friendly.find(params[:id])
    else
      @user = current_user
    end
  end

end
