class Customer < ApplicationRecord
  has_many :subscriptions
  validates_presence_of :name, :email, :address
end
