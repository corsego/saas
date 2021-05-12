module SetTenant
  extend ActiveSupport::Concern

  included do
    set_current_tenant_through_filter # acts_as_tenant
    before_action :set_tenant

    def set_tenant
      if current_user && current_user.tenant_id.present? && current_user.tenants.include?(current_user.tenant)
        current_account = current_user.tenant
        set_current_tenant(current_account)
      else
        set_current_tenant(nil)
      end
    end
  end
end