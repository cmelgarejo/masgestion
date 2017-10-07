class CampaignDetail < ApplicationRecord
  belongs_to :campaign
  has_many :users
  has_many :clients

  #self.primary_key = [:campaign_id, :client_id, :user_id]

end