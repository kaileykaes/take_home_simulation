require 'rails_helper'

RSpec.describe 'Subscription Cancellation', type: :request do
  before(:each) do 
    tea_1 = create(:tea)
    tea_2 = create(:tea)
    tea_3 = create(:tea)

    @customer = create(:customer)
    @subscription_1 = create(:subscription, customer: @customer)
    @subscription_2 = create(:subscription, customer: @customer)
    
    create(:subscription_tea, subscription: @subscription_1, tea: tea_1)
    create(:subscription_tea, subscription: @subscription_1, tea: tea_2)
    create(:subscription_tea, subscription: @subscription_1, tea: tea_3)

    create(:subscription_tea, subscription: @subscription_2, tea: tea_1)
    create(:subscription_tea, subscription: @subscription_2, tea: tea_1)
    create(:subscription_tea, subscription: @subscription_2, tea: tea_2)
    create(:subscription_tea, subscription: @subscription_2, tea: tea_3)
  end

  describe 'happy path' do
    it 'cancels existing subscription' do 
      params = {
        status: 0
      }
  
      put "/api/v1/customers/#{@customer.id}/subscriptions/#{@subscription_1.id}", params: params
      
      expect(response).to be_successful
      expect(response.status).to eq(204)
      
      success_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(success_message).to eq('Success! Subscription cancelled. 😄')
      expect(@subscription_1.status).to eq('inactive') 
    end
  end
end