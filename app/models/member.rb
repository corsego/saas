# == Schema Information
#
# Table name: members
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  tenant_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  roles      :jsonb            not null
#  slug       :string
#
class Member < ApplicationRecord
  belongs_to :user, counter_cache: true
  # User.find_each { |x| User.reset_counters(x.id, :members) }
  # Tenant.find_each { |x| Tenant.reset_counters(x.id, :members) }
  # belongs_to :tenant #acts_as_tenant includes this
  # acts_as_tenant(:tenant, counter_cache: true)
  acts_as_tenant :tenant, counter_cache: true
  # validates_uniqueness_to_tenant :user_id

  validates :tenant_id, presence: true
  validates_uniqueness_of :user_id, scope: :tenant_id

  def to_s
    user.email.to_s + tenant.name.to_s
  end

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  include Roleable

end
