Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/customers/:customer_id/subscriptions', to: 'customers/subscriptions#index'
      post '/customers/:customer_id/subscriptions', to: 'customers/subscriptions#create'
      patch '/customers/:customer_id/subscriptions/:id', to: 'customers/subscriptions#update'
    end
  end
end
