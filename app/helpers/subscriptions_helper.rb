module SubscriptionsHelper

  # logic to subscribe to a specific plan
  def subscribe_to(plan)
    if user_signed_in?
      if current_user.tenant.present?
        if current_user.tenant.subscription.present?
          t(".you_already_are_subscribed")
        elsif Member.find_by(user: current_user, tenant: current_user.tenant).admin?
          button_to "#{t(".subscribe").capitalize}: #{plan.name}", subscriptions_path(plan: plan), method: :post
        else
          t(".contact_admin_to_subscribe", tenant: current_user.tenant)
        end
      else
        t(".create_a_tenant_to_select_plan")
      end
    else
      link_to t("header.register"), new_user_registration_path, class: "btn btn-xl btn-success"
    end
  end

  # temporary solution while not using a gem like money. for superadmin dashboard
  def integer_to_currency(amount)
    "%.2f" % Rational(amount.to_i, 100)
  end

end