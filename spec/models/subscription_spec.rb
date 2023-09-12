require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should have_many(:teas).through(:subscription_teas) }
  it { should belong_to :customer }
  it { should define_enum_for(:status).with_values(inactive: 0, active: 1) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :frequency }
  
  describe 'methods' do 
    before(:each) do 
      @tea_1 = create(:tea, price: 10.00)
      @tea_2 = create(:tea, price: 12.00)
      @tea_3 = create(:tea, price: 9.50)

      @customer = create(:customer)
      @subscription = create(:subscription, customer: @customer)
      @st_1 = create(:subscription_tea, subscription: @subscription, tea: @tea_1)
      @st_2 = create(:subscription_tea, subscription: @subscription, tea: @tea_2)
      @st_3 = create(:subscription_tea, subscription: @subscription, tea: @tea_3)
    end

    it 'tallies cost based on tea prices' do 
      expect(@subscription.cost).to eq(31.50)
    end
  end
end
