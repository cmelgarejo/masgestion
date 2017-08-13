class CreateOpportunities < ActiveRecord::Migration[5.0]
  def change
    create_table :opportunities do |t|
      t.references :company, type: :uuid, foreign_key: true, index: true
      t.references :user
      t.string :name, null: false
      t.integer :stage # Enum
      t.date :close_date
      t.float :probability, default: 0
      t.decimal :amount, default: 0
      t.decimal :discount, default: 0

      t.timestamps
    end
  end
end

