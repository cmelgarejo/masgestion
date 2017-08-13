class CreateClientCollectionHistory < ActiveRecord::Migration[5.0]
  def change
    create_table :client_collection_history do |t|
      t.references :client, type: :uuid, foreign_key: true, index: true
      t.references :client_collection_category, foreign_key: true, index: { name: 'index_client_collection_history_on_category_id' }
      t.references :client_collection_type, foreign_key: true, index: { name: 'index_client_collection_history_on_category_type_id' }
      t.decimal :promise_amount, default: 0
      t.date :promise_date
      t.text :observations
      t.boolean :debt_collector, default: false

      t.timestamps
    end
  end
end
