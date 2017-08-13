class CreateCampaignDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :campaign_details, id: false do |t|
      t.references :campaign, type: :uuid, foreign_key: true, index: true
      t.references :client, type: :uuid, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.text :observations
      
      t.timestamps
    end
  end
end
