class CampaignDetail < ApplicationRecord
  has_many :users
  has_many :clients

end