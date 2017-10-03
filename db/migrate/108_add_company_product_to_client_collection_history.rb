class AddCompanyProductToClientCollectionHistory < ActiveRecord::Migration[5.0]
  def change
    add_reference :client_collection_history, :client_product, foreign_key: true, null: true
    add_reference :client_collection_history, :client_contact_mean, foreign_key: true, null: true
  end
end
