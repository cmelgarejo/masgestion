class Portfolio < ApplicationRecord
  belongs_to :company
  has_many :campaigns

end
