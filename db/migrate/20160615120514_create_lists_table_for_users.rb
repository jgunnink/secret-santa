class CreateListsTableForUsers < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.integer :user, index: true, null: false
    end

    create_table :santas do |t|
      t.string :email, index: true, null: false
      t.string :name, null: false
      t.integer :list
    end
  end
end
