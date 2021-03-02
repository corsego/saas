class CustomerPortalSessionsController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root

  def create
    portal_session = Stripe::BillingPortal::Session.create({
      customer: current_tenant.stripe_customer_id,
      return_url: url_for(controller: 'tenants', action: 'show', id: current_tenant.id, only_path: false)
    })
    redirect_to portal_session.url
  end
end
