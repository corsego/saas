# == Schema Information
#
# Table name: plans
#
#  id          :bigint           not null, primary key
#  name        :string
#  amount      :integer
#  currency    :string
#  interval    :string
#  max_members :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Plan < ApplicationRecord
  validates :name, :amount, :currency, :interval, :max_members, presence: true

  INTERVALS = %w[month year forever]
  validates :interval, inclusion: {in: INTERVALS, message: "%{value} is not available."}

  validates :amount, numericality: {greater_than_or_equal_to: 0, less_than: 100000}
  validates :max_members, numericality: {greater_than_or_equal_to: 1, less_than: 1000}

  has_many :subscriptions, dependent: :restrict_with_error

  def interval_period
    if interval == "forever"
      100.years
    elsif interval == "month"
      1.month
    elsif interval == "year"
      1.year
    end
  end

  def to_s
    name
  end
end
