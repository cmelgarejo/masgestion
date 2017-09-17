class ClientCollectionCategory < ApplicationRecord
  has_paper_trail
  validates :description, presence: true

  def name
    self.description
  end

  def client_collection_category
    ClientCollectionCategory.all.map do |category|
      [category.description, category.id]
    end.to_h
  end

  def self.all_for_select
    ClientCollectionCategory.all.map do |category|
      [category.description, category.id]
    end.to_h
  end
end
