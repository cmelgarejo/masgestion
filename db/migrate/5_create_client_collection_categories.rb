class CreateClientCollectionCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :client_collection_categories do |t|
      t.string :description, null: false, index: true

      t.timestamps
    end
  end
end
