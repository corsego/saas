class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :tenant
  
  validates :tenant_id, uniqueness: true
  validates :ends_at, presence: true

  def active?
    ends_at > Time.now
  end

end
