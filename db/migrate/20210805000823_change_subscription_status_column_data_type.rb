class ChangeSubscriptionStatusColumnDataType < ActiveRecord::Migration[5.2]
  def change
    change_column :subscriptions, :status, :string
  end
end
