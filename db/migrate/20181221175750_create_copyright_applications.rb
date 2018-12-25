class CreateCopyrightApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :copyright_applications do |t|
      t.integer :customer_id
      t.integer :acceptor_id
      t.integer :executor_id
      t.integer :product_id
      t.string :title
      t.string :keywords
      t.string :status, default: 'created'
      t.boolean :is_paid, default: false

      t.timestamps
    end
  end
end
