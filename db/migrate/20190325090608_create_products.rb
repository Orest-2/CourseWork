class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.integer :product_type

      t.timestamps
    end
  end
end
