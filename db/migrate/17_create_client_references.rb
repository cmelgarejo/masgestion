class CreateClientReferences < ActiveRecord::Migration[5.0]
  def change
    create_table :client_references do |t|
      t.references :client, type: :uuid, foreign_key: true, index: true
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.text :observations
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
