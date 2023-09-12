class RemoveColumnFromSubscriptions < ActiveRecord::Migration[7.0]
  def change
    remove_column :subscriptions, :cost, :float
  end
end
