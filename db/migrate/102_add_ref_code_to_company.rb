class AddRefCodeToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :ref_code, :string
  end
end
