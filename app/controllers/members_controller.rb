class MembersController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root
  include SetCurrentMember # for role-based authorization. @current_member.admin?
  include RequireActiveSubscription # no access unless tenant has an active subscription

  before_action :set_member, only: [:show, :edit, :update, :destroy]

  before_action :require_tenant_admin, only: [:invite, :edit, :update, :destroy]

  def index
    @q = Member.ransack(params[:q])
    @members = @q.result.includes(:user, :tenant)
    # @members = Member.includes(:user, :tenant).all # "includes" for eager loading
  end

  def invite
    if current_tenant.can_invite_members?
      email = params[:email]
      user_from_email = User.find_by(email: email)
      if email.present?
        if user_from_email.present? # user exists in the database
          if Member.where(user: user_from_email).any? # user is a member in current_tenant
            redirect_to members_path, alert: "The organization #{current_tenant.name} already has a user with the email #{email}"
          else # user is not a member of current_tenant
            new_member = Member.create!(user: user_from_email, editor: true) # create member for existing user
            MemberMailer.invited(new_member).deliver_later
            redirect_to members_path, notice: "#{email} was invited to join the organization #{current_tenant.name}"
          end
        elsif user_from_email.nil? # invite new user to a tenant
          new_user = User.invite!({email: email}, current_user) # devise invitable create user and send email. invited_by current_user
          if new_user.persisted?
            Member.create!(user: new_user, editor: true) # make new user part of this tenant
            redirect_to members_path, notice: "#{email} was invited to join the tenant #{current_tenant.name}"
          else
            redirect_to members_path, alert: "Something went wrong. Please try again"
          end
        end
      else
        redirect_to members_path, alert: "No email provided!"
      end
    else
      redirect_to members_path, alert: "You have reached the limit. Please upgrade you plan."
    end
  end

  def show
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to @member, notice: "Member was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @member.destroy
    redirect_to members_url, notice: "Member was successfully destroyed."
  end

  private

  def set_member
    @member = Member.friendly.find(params[:id])
    # decrease search scope
    # @member = current_tenant.members.friendly.find(params[:id])
  end

  def member_params
    params.require(:member).permit(*Member::ROLES)
  end

  def require_tenant_admin
    unless @current_member.admin?
      redirect_to members_path, alert: "You are not authorized to invite, edit, update, destory members"
    end
  end
end
