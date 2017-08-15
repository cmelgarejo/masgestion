class CompanyProduct < ApplicationRecord
  has_paper_trail
  belongs_to :company
  belongs_to :product_type
  validates :description, presence: true

  def name
    self.description
  end

  def self.all_for_select
    CompanyProduct.all.map do |product|
      ["#{product.company.name} - #{product.product_type.description} - #{product.name}", product.id]
    end.to_h
  end
end