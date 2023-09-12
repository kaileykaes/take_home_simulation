require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many :subscriptions}
  it { should validate_presence_of :name}
  it { should validate_presence_of :email}
  it { should validate_presence_of :address}
end
