class CheckoutController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root

  def create
    tenant = Tenant.find(params[:id])

    if tenant.nil?
      redirect_to root_path
      return
    end

    @session = Stripe::Checkout::Session.create(
      customer: current_tenant.stripe_customer_id,
      payment_method_types: ['card'],
      line_items: [{
          name: tenant.plan.name,
          description: "max_members: #{tenant.plan.max_members}",
          amount: tenant.plan.amount,
          currency: tenant.plan.currency,
          quantity: 1
      }],
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url
    )

    respond_to do |format|
      format.js # renders create.js.erb
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
  end
end
