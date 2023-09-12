require 'rails_helper'

RSpec.describe 'Subscription Serializer' do
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

  describe 'serialization' do
    it 'serializes collection' do 
      subscriptions = Subscription.where(customer: @customer)
      serialized = SubscriptionSerializer.new(subscriptions, is_collection: true).serializable_hash.to_json

      parsed = JSON.parse(serialized, symbolize_names: true)
      
      check_hash_structure(parsed, :data, Array)
      
      subscribed = parsed[:data]
      
      subscribed.each do |subscription|
        check_hash_structure(subscription, :id, String)
        check_hash_structure(subscription, :type, String)
        expect(subscription[:type]).to eq('subscription')
        check_hash_structure(subscription[:attributes], :cost, Float)
        check_hash_structure(subscription[:attributes], :status, String)
        check_hash_structure(subscription[:attributes], :title, String)
        check_hash_structure(subscription[:attributes], :frequency, String)
        check_hash_structure(subscription[:attributes], :customer_id, Integer)
        check_hash_structure(subscription[:attributes], :created_at, String)
        check_hash_structure(subscription[:attributes], :updated_at, String)
      end
    end
    
    it 'serializes a single subscription' do 
      subscription = Subscription.first
      serialized = SubscriptionSerializer.new(subscription).serializable_hash.to_json

      parsed = JSON.parse(serialized, symbolize_names: true)
      check_hash_structure(parsed, :data, Hash)

      single_subscription = parsed[:data]
      
      check_hash_structure(single_subscription, :id, String)
      check_hash_structure(single_subscription, :type, String)
      expect(single_subscription[:type]).to eq('subscription')
      check_hash_structure(single_subscription, :attributes, Hash)
      check_hash_structure(single_subscription[:attributes], :cost, Float)
      check_hash_structure(single_subscription[:attributes], :status, String)
      check_hash_structure(single_subscription[:attributes], :title, String)
      check_hash_structure(single_subscription[:attributes], :frequency, String)
      check_hash_structure(single_subscription[:attributes], :customer_id, Integer)
      check_hash_structure(single_subscription[:attributes], :created_at, String)
      check_hash_structure(single_subscription[:attributes], :updated_at, String)
    end
  end
end