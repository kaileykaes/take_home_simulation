class Api::V1::SubscriptionsController < Api::V1::BaseController
  before_action :find_subscription, only: :update
  before_action :find_customer

  def index
    subscriptions = Subscription.all.where(customer_id: params[:customer_id])
    render json: SubscriptionSerializer.new(subscriptions, is_collection: true).serializable_hash.to_json
  end
  
  def create
    response.status = 201
    subscription = Subscription.create!(subscription_params)
    tea_attachment(subscription)
    render json: SubscriptionSerializer.new(subscription)
  end
  
  def update
    @subscription.update(subscription_params)
    render json: SubscriptionSerializer.new(@subscription)
  end

  private
  def find_customer
    @customer = Customer.find(params[:customer_id])
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.permit(:frequency, :title, :customer_id, :status)
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