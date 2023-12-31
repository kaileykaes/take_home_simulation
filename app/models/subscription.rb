class Subscription < ApplicationRecord
  validates :title, :frequency, presence: true
  belongs_to :customer
  has_many :subscription_teas, dependent: :destroy
  has_many :teas, through: :subscription_teas
  enum status: { inactive: 0, active: 1 }

  def cost
    teas.sum(:price)
  end
end
