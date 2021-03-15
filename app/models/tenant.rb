# == Schema Information
#
# Table name: tenants
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#  members_count :integer          default(0), not null
#
class Tenant < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :name, length: {in: 2..20}
  RESERVED_NAMES = %w[blog app pricing terms help support tenant tenants user users]
  validates :name, exclusion: {in: RESERVED_NAMES, message: "%{value} is reserved."}
  validates :name, format: { with: /\A[a-z][a-z0-9\-]+[a-z0-9]\Z/, message: "contains invalid symbols" }

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  def to_s
    name
  end

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_one_attached :logo
  validates :logo, content_type: [:png, :jpg, :jpeg],
                   size: {less_than: 200.kilobytes, message: "Logo has to be under 200 kilobytes"}

  include Subscribable

  def can_invite_members?
    members_count < plan.max_members
  end
end
