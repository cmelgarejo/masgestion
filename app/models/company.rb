class Company < ApplicationRecord
  has_paper_trail
  has_many :users
  has_many :company_products
end