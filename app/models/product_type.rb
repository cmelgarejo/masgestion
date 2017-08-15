class ProductType < ApplicationRecord
  has_paper_trail
  validates :description, presence: true
end
