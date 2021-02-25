class CustomerPortalSessionsController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root

  def create
    portal_session = Stripe::BillingPortal::Session.create({
      # customer: "cus_IxbdhrQbzIE5hm",
      # customer: current_user.tenant.stripe_customer_id,
      # customer: ActsAsTenant.current_tenant.stripe_customer_id,
      customer: current_tenant.stripe_customer_id,
      return_url: url_for(controller: 'tenants', action: 'show', id: current_tenant.id, only_path: false)
      # return_url: 'https://9a16ebb9445a4fcd9440a0c649c89d0c.vfs.cloud9.eu-central-1.amazonaws.com/',
    })
    redirect_to portal_session.url
  end
end
