class ClientProductPayment  < ApplicationRecord
  has_paper_trail
  belongs_to :client
  belongs_to :client_product

end
