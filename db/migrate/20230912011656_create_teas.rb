class CreateTeas < ActiveRecord::Migration[7.0]
  def change
    create_table :teas do |t|
      t.string :name
      t.float :price
      t.string :description

      t.timestamps
    end
  end
end
