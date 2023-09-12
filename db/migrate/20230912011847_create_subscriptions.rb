class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.float :cost
      t.string :frequency
      t.integer :status, default: 1
      t.string :title
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
