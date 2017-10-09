class ClientReference < ApplicationRecord
  has_paper_trail
  belongs_to :client
  validates :first_name, presence: true
end
