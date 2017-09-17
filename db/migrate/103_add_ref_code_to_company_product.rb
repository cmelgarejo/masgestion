class AddRefCodeToCompanyProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :company_products, :ref_code, :string
  end
end
