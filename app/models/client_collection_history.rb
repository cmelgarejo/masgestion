class ClientCollectionHistory < ApplicationRecord
  self.table_name = 'client_collection_history'
  has_paper_trail
  belongs_to :client_collection_category
  belongs_to :client_collection_type
  belongs_to :client
  belongs_to :user

end
