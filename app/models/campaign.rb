class Campaign < ApplicationRecord
  has_paper_trail
  belongs_to :portfolio

end
