class AddSantaListsJoin < ActiveRecord::Migration
  def change
    create_table :santa_lists do |t|
      t.belongs_to :santas, index: true, null: false
      t.belongs_to :lists, index: true, null: false
    end

    remove_column :santas, :list
  end
end
