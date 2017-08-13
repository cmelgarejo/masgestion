class CreateClientProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :client_products do |t|
      t.references :client, type: :uuid, foreign_key: true, index: true
      t.references :company_product, foreign_key: true
      t.decimal :balance, default: 0
      t.decimal :arrears, default: 0
      t.decimal :total_with_arrears, default: 0 # balance + penalty_interest
      t.integer :days_late, default: 0
      t.text :observations

      t.timestamps
    end
    add_index :client_products, [:company_product_id, :client_id]
  end
end
