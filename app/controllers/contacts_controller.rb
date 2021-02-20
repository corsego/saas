class ContactsController < ApplicationController
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root
  include SetCurrentMember # for role-based authorization. @current_member.admin?
  include RequireActiveSubscription # no access unless tenant has an active subscription

  before_action :set_contact, only: %i[show edit update destroy]
  before_action :require_tenant_admin_or_editor, only: %i[edit update destroy]

  def import
    @contacts = request.env["omnicontacts.contacts"]
    @user = request.env["omnicontacts.user"]

    @contacts.each do |contact|
      Contact.find_or_create_by(email: contact[:email],
                                first_name: contact[:first_name],
                                last_name: contact[:last_name],
                                phone_number: contact[:phone_number],
                                import_id: contact[:id],
                                source: @user[:email]).save(validate: false)
    end

    redirect_to contacts_path, notice: "Successfully imported"
  end

  def failure
    redirect_to contacts_path, alert: "Failure. Please try again."
  end

  def index
    @contacts = Contact.all
  end

  def show
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to @contact, notice: "Contact was successfully created."
    else
      render :new
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: "Contact was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_url, notice: "Contact was successfully destroyed."
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :phone_number, :email)
  end

  def require_tenant_admin_or_editor
    unless @current_member.admin? || @current_member.editor?
      redirect_to contacts_path, alert: "You are not authorized to edit, update, destroy"
    end
  end
end
