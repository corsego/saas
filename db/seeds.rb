# rails db:drop db:create db:migrate db:seed
User.create!(email: "admin@example.com", password: "admin@example.com", password_confirmation: "admin@example.com")
Tenant.create!(name: "microsoft")
Member.create!(tenant: Tenant.first, user: User.first, admin: true)
User.update_all confirmed_at: DateTime.now

# User.first.toggle(:superadmin) # will not work because superadmin is not a whitelisted param (good for security)
# User.first.update!(superadmin: true) # will not work because superadmin is not a whitelisted param (good for security)
# Member.first.update!(admin: true)

Plan.create(name: "solo", amount: 0, currency: "usd", interval: "forever", max_members: 1)
Plan.create(name: "team", amount: 1000, currency: "usd", interval: "month", max_members: 15)
Plan.create(name: "team yearly", amount: 10000, currency: "usd", interval: "year", max_members: 15)
