class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end