class Campaign < ApplicationRecord
  belongs_to :portfolio
  has_many :campaign_details, dependent: :delete_all
  validates :name, presence: true

  enum status: [:planned, :started, :completed, :on_hold, :called_off]

  def self.statuses_for_select
    statuses.map do |status, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.i18n.status.#{status}"), status]
    end.to_h
  end

  def self.user_campaigns(user_id)
    #CampaignDetail.where(campaign_id: self.ids, user_id: user_id).map {|c| [c, Campaign.find(c).name]}.uniq
    self.find(CampaignDetail.where(campaign_id: self.ids, user_id: user_id).map(&:campaign_id).uniq).map {|c| [c.name, c.id]}
  end
end