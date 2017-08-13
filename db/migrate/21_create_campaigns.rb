class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns, id: :uuid do |t|
      t.string :name, null: false
      t.date :start
      t.date :end
      t.integer :status, default: 0
      t.boolean :active, default: true
      t.references :portfolio, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
