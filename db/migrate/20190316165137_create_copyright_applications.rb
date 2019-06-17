class CreateCopyrightApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :copyright_applications do |t|
      t.integer :customer_id, :null => false
      t.integer :director_id, :default => nil
      t.integer :acceptor_id, :default => nil
      t.integer :executor_id, :default => nil

      t.string :title, :null => false
      t.string :description
      t.integer :status, :default => 0

      t.timestamps
    end
  end
end
