class Tenant < ApplicationRecord
  
  validates :name, presence: true, uniqueness: true
  validates :name, length: { in: 2..20 }

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  def to_s
    name
  end

  extend FriendlyId
  friendly_id :name, use: :slugged
  def should_generate_new_friendly_id? #will change the slug if the name changed
    #source https://www.rubydoc.info/github/norman/friendly_id/FriendlyId%2FSlugged:should_generate_new_friendly_id%3F
    name_changed?
  end
end
