class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :title
      t.decimal :amount
      t.integer :category
      t.date :transaction_date

      t.timestamps
    end
  end
end
