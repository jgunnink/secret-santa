class CreateSantasTableForLists < ActiveRecord::Migration
  def change
    create_table :santas do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.integer :list_id, index: true, null: false
      t.timestamps index: true, null: false
    end
  end
end
