class CampaignDetail < ApplicationRecord
  belongs_to :campaign
  belongs_to :users
  belongs_to :clients

  #self.primary_key = [:campaign_id, :client_id, :user_id]

end