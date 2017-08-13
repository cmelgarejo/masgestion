class CreateCompanyProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :company_products do |t|
      t.references :company, type: :uuid, foreign_key: true, index: true
      t.references :product_type, foreign_key: true
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
