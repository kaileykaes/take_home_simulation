class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :frequency, :status, :title, :customer_id, :created_at, :updated_at, :cost, :teas
end