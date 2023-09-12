class Api::V1::SubscriptionsController < ApplicationController
  def index
    subscriptions = Subscription.all.where(customer_id: params[:customer_id])
    render json: SubscriptionSerializer.new(subscriptions, is_collection: true).serializable_hash.to_json
  end
end