class AddStripeCustomerIdToTenants < ActiveRecord::Migration[6.1]
  def change
    add_column :tenants, :stripe_customer_id, :string
    add_index :tenants, :stripe_customer_id, unique: true
  end
end
