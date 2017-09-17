class AddOriginalDataToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :original_data, :jsonb
  end
end
