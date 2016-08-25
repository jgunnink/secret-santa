class AddLockedToList < ActiveRecord::Migration
  def change
    add_column :lists, :is_locked, :boolean, null: false, default: false
  end
end
