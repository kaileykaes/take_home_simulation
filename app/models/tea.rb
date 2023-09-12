class Tea < ApplicationRecord
  has_many :subscription_teas, dependent: :destroy
  has_many :subscriptions, through: :subscription_teas
end
