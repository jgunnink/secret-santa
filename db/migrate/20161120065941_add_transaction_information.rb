class AddTransactionInformation < ActiveRecord::Migration
  def change
    create_table :processed_transactions do |t|
      t.string :transaction_id, index: true, null: false
      t.integer :list_id, index: true, null: false
      t.timestamps index: true, null: false
    end

    change_column_default :lists, :limited, true
  end
end
