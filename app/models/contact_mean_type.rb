class ContactMeanType < ApplicationRecord
  has_paper_trail
  validates :description, presence: true

  def name
    self.description
  end

  def to_s
    name
  end
end
