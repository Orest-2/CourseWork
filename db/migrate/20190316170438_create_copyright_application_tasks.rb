class CreateCopyrightApplicationTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :copyright_application_tasks do |t|

      t.integer :copyright_application_id, :null => false
      t.string :title, :null => false
      t.boolean :done, :default => false

      t.timestamps
    end
  end
end
