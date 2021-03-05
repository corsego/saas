class WebhooksController < ApplicationController
  # stripe trigger customer.created
  # stripe listen --forward-to https://9a16ebb9445a4fcd9440a0c649c89d0c.vfs.cloud9.eu-central-1.amazonaws.com/webhooks

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials[Rails.env.to_sym][:stripe][:webhook]
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts "Signature error"
      p e
      return
    end

    # Handle the event
    case event.type
    when 'charge.succeeded'
      @user = User.find_by(email: "yshmarov@gmail.com").update(name: Time.zone.now)
    #when 'checkout.session.completed'
    #  session = event.data.object
    #  @user = User.find_by(stripe_customer_id: session.customer)
    #  @user.update(subscription_status: 'active')
    #when 'customer.subscription.updated', 'customer.subscription.deleted'
    #  subscription = event.data.object
    #  @user = User.find_by(stripe_customer_id: subscription.customer)
    #  @user.update(
    #    subscription_status: subscription.status,
    #    plan: subscription.items.data[0].price.lookup_key,
    #  )
    end

    render json: { message: 'success' }
  end
end
