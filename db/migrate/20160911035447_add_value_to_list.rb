class AddValueToList < ActiveRecord::Migration
  def change
    add_column :lists, :gift_value, :integer
  end
end
