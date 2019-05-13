class AddProductIdToCopyrightApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :copyright_applications, :product_id, :integer
  end
end
