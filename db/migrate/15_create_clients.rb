class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :document_type, foreign_key: true, null: false
      t.string :document, null: false
      t.date :birthdate
      t.string :address
      t.string :country
      t.string :state
      t.string :city
      t.float :lat
      t.float :lng
      t.boolean :active, default: true

      t.references :company, type: :uuid, index: true

      t.timestamps
    end
    add_index :clients, [:document_type_id, :document]
    add_index :clients, [:country, :state]
    add_index :clients, [:country, :state, :city]
    execute 'CREATE INDEX index_clients_latlng_spgist ON clients USING spgist(point(lat, lng));'
  end
end
