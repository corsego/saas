class ChargesController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root

  before_action :require_subscription, only: %i[charge]

  def charge
    subscription = current_tenant.subscription
    plan = subscription.plan

    if plan.amount > 0
      # payment provider logic
    end

    charge = Charge.create(
      subscription: subscription,
      period_start: subscription.ends_at,
      period_end: subscription.ends_at + subscription.plan.interval_period,
      plan_name: plan.name,
      plan_amount: plan.amount,
      plan_currency: plan.currency,
      plan_interval: plan.interval,
      plan_conditions: plan.max_members
    )

    if charge.save
      subscription.update(ends_at: subscription.ends_at + subscription.plan.interval_period)
      redirect_to tenant_path(current_tenant), notice: "Charged successfully. Subscription updated."
    else
      redirect_to tenant_path(current_tenant), alert: "Something went wrong. Please try again."
    end
  end

  private

  def require_subscription
    unless current_tenant.subscription.present?
      redirect_to pricing_path, alert: "Please select a plan to access the app"
    end
  end
end
