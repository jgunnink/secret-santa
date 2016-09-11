class AddValueToList < ActiveRecord::Migration
  def change
    # Adds a decimal column with 6 numbers, to two decimal places. Eg: 1234.56
    add_column :lists, :gift_value, :decimal, precision: 6, scale: 2
  end
end
