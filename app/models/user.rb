# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  tenant_id              :integer
#  members_count          :integer          default(0), not null
#  slug                   :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  provider               :string
#  name                   :string
#  image                  :string
#  superadmin             :boolean          default(FALSE)
#  language               :string
#  time_zone              :string           default("UTC")
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :invitable,
    :confirmable,
    :trackable,
    :omniauthable
  # :omniauthable, omniauth_providers: [:google_oauth2, :github, :twitter, :facebook]
  # if omniauth providers are not listed, gets them from devise.rb

  has_many :identities, dependent: :destroy
  has_many :members, dependent: :restrict_with_error
  has_many :tenants, through: :members

  # tenant_id = to get current_tenant; false = can exist without any tenants
  belongs_to :tenant, required: false

  def to_s
    email
  end

  def username
    if name.present?
      name
    else
      email.split(/@/).first
    end
  end

  extend FriendlyId
  friendly_id :email, use: :slugged

  validates :time_zone, presence: true, inclusion: {in: TZInfo::Timezone.all_identifiers}
  # validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }
end
