class HistoryType < ApplicationRecord
  has_paper_trail
  validates :description, presence: true

  def name
    self.description
  end

  def to_s
    name
  end

  def self.all_for_select
    HistoryType.all.map do |history_type|
      [history_type.name, history_type.id]
    end.to_h
  end
end