class AddHistoryTypesToClientCollectionHistory < ActiveRecord::Migration[5.0]
  def change
    add_reference :client_collection_history, :history_type, foreign_key: true
  end
end
