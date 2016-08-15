class AddRecipientToSanta < ActiveRecord::Migration
  def change
    add_column :santas, :giving_to, :integer, index: true
  end
end
