class AddRefCodeToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :ref_code, :string
  end
end
