class CheckoutController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root

  def create
    @session = Stripe::Checkout::Session.create(
      customer: current_tenant.stripe_customer_id,
      payment_method_types: ['card'],
      line_items: [{
        # name: current_tenant.plan.name,
        # description: "max_members: #{current_tenant.plan.max_members}",
        # amount: current_tenant.plan.amount,
        # currency: current_tenant.plan.currency,
        price: "price_1IVQVWEVfZXx8H2ceIFOtYha",
        quantity: 1
      }],
      mode: 'subscription',
      # mode: 'payment',
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url
    )

    respond_to do |format|
      format.js # renders create.js.erb
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
  end

  def cancel
    redirect_to tenant_url(current_tenant), notice: "Transaction: Cancelled"
  end

end
