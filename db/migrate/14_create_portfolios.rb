class CreatePortfolios < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolios, id: :uuid do |t|
      t.references :company, type: :uuid, foreign_key: true, index: true
      t.string :name, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
