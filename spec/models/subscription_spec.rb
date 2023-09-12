require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it {should have_many(:teas).through(:subscription_teas)}
  it {should belong_to :customer }
  it {should define_enum_for(:status).with_values(inactive: 0, active: 1) }
end
