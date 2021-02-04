module Roleable

  extend ActiveSupport::Concern
  included do

    # List member roles
    ROLES = [:admin, :editor, :viewer]
    # Member.find(13).update_attributes!(admin: true) #add admin in console
  
    # json column to store roles
    store_accessor :roles, *ROLES
  
    # boolean roles
    ROLES.each do |role|
      scope role, -> { where("roles @> ?", {role => true}.to_json) }
      define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
      define_method(:"#{role}?") { send(role) }
    end
  
    def active_roles # Where value true
      ROLES.select { |role| send(:"#{role}?") }.compact
    end
  
    # role validation
    validate :must_have_a_role, on: :update
    validate :must_have_an_admin
  
    private
  
    def must_have_an_admin
      if persisted? &&
          (tenant.members.where.not(id: id).pluck(:roles).count { |h| h["admin"] == true } < 1) &&
          roles_changed? && admin == false
        errors.add(:base, "The tenant must have at least one admin")
      end
    end
  
    def must_have_a_role
      if roles.values.none?
        errors.add(:base, "A member must have at least one role")
      end
    end

  end
end