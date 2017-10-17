class AddIdToCampaignDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :campaign_details, :id, :primary_key
    add_column :campaign_details, :order, :integer, default: 0
    add_index :campaign_details, [:campaign_id, :client_id, :user_id], unique: true
  end
end
