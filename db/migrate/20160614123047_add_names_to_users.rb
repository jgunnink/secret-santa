class AddNamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :given_names, :string
    add_column :users, :last_name, :string
  end
end
