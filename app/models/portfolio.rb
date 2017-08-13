class Portfolio < ApplicationRecord
  has_paper_trail
  belongs_to :company
  has_many :campaigns

end
