class AddLimitedToLists < ActiveRecord::Migration
  def change
    add_column :lists, :limited, :boolean, null: false, default: true
  end
end
