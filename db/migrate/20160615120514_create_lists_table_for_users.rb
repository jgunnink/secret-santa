class CreateListsTableForUsers < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name, index: true, null: false
      t.integer :user_id, index: true, null: false
      t.timestamps index: true, null: false
    end
  end
end
