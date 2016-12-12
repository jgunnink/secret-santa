class AddRevealedToLists < ActiveRecord::Migration
  def change
    add_column :lists, :revealed, :boolean, null: false, default: false
  end
end
