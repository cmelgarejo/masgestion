class CreateClientContactMeans < ActiveRecord::Migration[5.0]
  def change
    create_table :client_contact_means do |t|
      t.references :contact_mean_type, foreign_key: true, index: true
      t.references :client, type: :uuid, foreign_key: true, index: true
      t.string :target, null: false
      t.text :observations
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
