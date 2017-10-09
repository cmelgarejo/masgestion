class CreateClientImports < ActiveRecord::Migration[5.0]
  def change
    create_table :client_imports do |t|
      t.references :client, type: :uuid, foreign_key: true
      t.jsonb :original_data

      t.timestamps
    end
  end
end
