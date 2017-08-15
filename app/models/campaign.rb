class Campaign < ApplicationRecord
  belongs_to :portfolio
  has_many :campaign_details
  validates :name, presence: true

  enum status: [:planned, :started, :completed, :on_hold, :called_off]

  def self.statuses_for_select
    statuses.map do |status, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.i18n.status.#{status}"), status]
    end.to_h
  end
end