class ChargesController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root
  include SetCurrentMember # for role-based authorization. @current_member.admin?

  before_action :require_subscription, only: %i[charge]

  def charge
    @subscription = current_tenant.subscription
    @plan = @subscription.plan

    if @plan.amount > 0
      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: @plan.amount,
        description: current_tenant.name,
        currency: @plan.currency
      )
    end

    @charge = Charge.create(
      subscription: @subscription,
      period_start: @subscription.ends_at,
      period_end: @subscription.ends_at + @subscription.plan.interval_period,
      plan_name: @plan.name,
      plan_amount: @plan.amount,
      plan_currency: @plan.currency,
      plan_interval: @plan.interval,
      plan_conditions: @plan.max_members
    )

    if @charge.save
      @subscription.update(ends_at: @subscription.ends_at + @subscription.plan.interval_period)
      redirect_to tenant_path(current_tenant), notice: "Charged successfully. Subscription updated."
    else
      redirect_to tenant_path(current_tenant), alert: "Something went wrong. Please try again."
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to tenant_path(current_tenant), alert: "Payment went wrong. Please try again."
  end

  private

  def require_subscription
    unless current_tenant.subscription.present?
      redirect_to pricing_path, alert: "Please select a plan to access the app"
    end
  end

end
