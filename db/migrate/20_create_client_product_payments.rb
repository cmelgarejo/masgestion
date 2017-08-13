class CreateClientProductPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :client_product_payments do |t|
      t.references :client, type: :uuid, foreign_key: true, index: true
      t.references :client_product, foreign_key: true, index: true
      t.decimal :value, default: 0
      t.date :payment_date
      t.text :observations

      t.timestamps
    end
  end
end
