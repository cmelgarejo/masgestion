class ClientCollectionCategory < ApplicationRecord
  has_paper_trail
  validates :description, presence: true

  def name
    self.description
  end
end
