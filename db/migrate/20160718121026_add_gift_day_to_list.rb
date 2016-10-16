class AddGiftDayToList < ActiveRecord::Migration
  def change
    add_column :lists, :gift_day, :date
  end
end
