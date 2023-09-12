require 'rails_helper'

RSpec.describe 'Subscriptions Index', type: :request do
  before(:each) do
    @tea_1 = create(:tea, price: 10.00)
    @tea_2 = create(:tea, price: 12.00)
    @tea_3 = create(:tea, price: 9.50)

    @customer = create(:customer)
    @subscription_1 = create(:subscription, customer: @customer)
    @subscription_2 = create(:subscription, customer: @customer)
    @st_1 = create(:subscription_tea, subscription: @subscription_1, tea: @tea_1)
    @st_2 = create(:subscription_tea, subscription: @subscription_1, tea: @tea_2)
    @st_3 = create(:subscription_tea, subscription: @subscription_1, tea: @tea_3)

    @st_4 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_1)
    @st_5 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_1)
    @st_6 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_2)
    @st_7 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_3)
  end

  describe 'happy paths' do
    it 'successfully makes request' do 
      get "/api/v1/customers/#{@customer.id}/subscriptions"

      expect(response).to be_successful
    end
  end
end