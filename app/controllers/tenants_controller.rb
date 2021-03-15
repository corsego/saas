class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[show edit update destroy switch]
  before_action :require_tenant_admin, only: %i[edit update destroy]
  before_action :require_tenant_member, only: %i[show]

  def index
    @q = current_user.tenants.order(created_at: :desc).ransack(params[:q])
    @tenants = @q.result.includes(:members, :users, :subscription, subscription: [:plan], members: [:user])
    # @tenants = current_user.tenants
  end

  def switch
    if current_user.tenants.include?(@tenant)
      current_user.update_attribute(:tenant_id, @tenant.id)
      redirect_to tenant_path(current_user.tenant), notice: t(".current_tenant", tenant: current_user.tenant.name)
    else
      redirect_to tenants_path, alert: t(".no_rights", tenant: @tenant.name)
    end
  end

  set_current_tenant_through_filter
  def show
    set_current_tenant(@tenant)
    @charges = @tenant.charges
    @subscription = @tenant.subscription
    @plan = @tenant.plan
  end

  def new
    @tenant = Tenant.new
  end

  def edit
  end

  def create
    @tenant = Tenant.new(tenant_params)

    if @tenant.save
      # when a tenant is created, the creator becomes a member
      @member = Member.create!(tenant: @tenant, user: current_user, admin: true)
      # when a tenant is created, the creator sets it as current_tenant
      current_user.update_attribute(:tenant_id, @tenant.id)
      create_stripe_customer(@tenant, current_user)
      redirect_to @tenant, notice: t(".created")
    else
      render :new
    end
  end

  def update
    if @tenant.update(tenant_params)
      redirect_to @tenant, notice: t(".updated")
    else
      render :edit
    end
  end

  def destroy
    if @tenant.destroy
      redirect_to tenants_url, notice: t(".destroyed")
    else
      # if has charges
      redirect_to tenants_url, alert: t(".cant_be_destroyed")
    end
  end

  private

  def set_tenant
    @tenant = Tenant.friendly.find(params[:id])
  end

  def tenant_params
    params.require(:tenant).permit(:name, :logo)
  end

  def require_tenant_admin
    unless current_user.tenants.include?(@tenant) &&
        Member.find_by(user: current_user, tenant: @tenant).admin?
      redirect_to tenants_path, alert: t("tenants.require_tenant_admin.alert")
    end
  end

  def require_tenant_member
    unless current_user.tenants.include?(@tenant)
      redirect_to tenants_path, alert: t("tenants.require_tenant_member.alert")
    end
  end

  # stripe
  def create_stripe_customer(tenant, user)
    customer = Stripe::Customer.create(
      email: user.email,
      metadata: {
        user_id: user.id,
        user_email: user.email,
        tenant_id: tenant.id,
        tenant_name: tenant.name
      }
    )
    tenant.update!(stripe_customer_id: customer.id)
    customer
  end

end
