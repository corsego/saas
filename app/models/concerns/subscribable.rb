module Subscribable
  extend ActiveSupport::Concern
  included do
    has_one :subscription, dependent: :destroy
    has_many :charges, dependent: :restrict_with_error
    has_one :plan, through: :subscription
  end
end
