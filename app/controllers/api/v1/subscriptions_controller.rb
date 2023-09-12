class Api::V1::SubscriptionsController < ApplicationController
  def index
    subscriptions = Subscription.all.where(customer_id: params[:customer_id])
    render json: SubscriptionSerializer.new(subscriptions, is_collection: true).serializable_hash.to_json
  end

  def create
    response.status = 201
    require 'pry'; binding.pry
    subscription = Subscription.create!(subscription_params)
    tea_attachment(subscription)
    render json: SubscriptionSerializer.new(subscription)
  end

  private
    def subscription_params
      params.permit(:frequency, :title, :customer_id)
    end

    def tea_attachment(subscription)
      teas.each do |tea|
        SubscriptionTea.create!(subscription_id: subscription.id, tea_id: tea[:id])
      end
    end

    def teas
      params[:teas]
    end
end