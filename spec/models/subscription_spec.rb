require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it {should have_many(:teas).through(:subscription_teas)}
  it {should belong_to :customer }
end
