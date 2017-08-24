class ClientProductPayment  < ApplicationRecord
  has_paper_trail
  belongs_to :client, optional: true
  belongs_to :client_product

end
