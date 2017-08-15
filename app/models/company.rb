class Company < ApplicationRecord
  has_many :users
  has_many :clients
  has_many :portfolios
  has_many :company_products
  validates :name, presence: true

  def is_active?
    self.active
  end
end