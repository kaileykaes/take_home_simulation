class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.float :cost
      t.string :frequency
      t.string :status
      t.string :title
      t.references :customers, null: false, foreign_key: true

      t.timestamps
    end
  end
end
