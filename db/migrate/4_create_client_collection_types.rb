class CreateClientCollectionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :client_collection_types do |t|
      t.string :description, null: false, index: true

      t.timestamps
    end
  end
end
