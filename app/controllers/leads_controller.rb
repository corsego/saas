class LeadsController < ApplicationController
  skip_before_action :authenticate_user!
  layout "errors"

  set_current_tenant_through_filter
  before_action :set_tenant, only: %i[new show create]

  def new
    @contact = Contact.new
  end

  # available only during the same session as the contact was created
  def show
    # if params[:created_session_id] == session.id.to_s
    @contact = Contact.find(params[:id])
    if @contact.created_session_id == session.id.to_s
      render "contacts/show"
    else
      redirect_to root_path, alert: "Session expired"
    end
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.created_session_id = session.id
    if @contact.save
      redirect_to tenant_lead_path(@tenant, @contact), notice: "Contact was successfully created."
    else
      render :new
    end
  end

  private

  def set_tenant
    @tenant = Tenant.friendly.find(params[:tenant_id])
    set_current_tenant(@tenant)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :phone_number, :email)
  end
end
