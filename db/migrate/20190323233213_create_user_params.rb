class CreateUserParams < ActiveRecord::Migration[5.2]
  def change
    create_table :user_params do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address

      t.timestamps
    end
  end
end
