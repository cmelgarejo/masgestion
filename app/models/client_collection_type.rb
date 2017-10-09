class ClientCollectionType < ApplicationRecord
  has_paper_trail
  validates :description, presence: true

  def name
    self.description
  end

  def to_s
    name
  end

  def self.all_for_select
    ClientCollectionType.all.map do |category|
      [category.name, category.id]
    end.to_h
  end
end
