class Api::V1::Customers::SubscriptionsController < ApplicationController
  before_action :set_customer
  before_action :set_tea

  def create
    sub = @customer.subscriptions.new(subscription_params)

    render json: SubscriptionSerializer.new(sub), status: 201
  end

  private

  def subscription_params
    params.permit(:customer_id, :tea_id, :title, :price, :status, :frequency)
  end

  def set_customer
    @customer = Customer.find_by(id: params[:customer_id])
  end

  def set_tea
    @tea = Tea.find_by(id: params[:tea_id])
  end
end
