class SubscriptionSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :customer_id, :tea_id, :title, :price, :status, :frequency
end
