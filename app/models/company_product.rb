class CompanyProduct < ApplicationRecord
  has_paper_trail
  belongs_to :company

end
