class CreateUserCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :user_companies, id: false do |t|
      t.references :user
      t.references :company, type: :uuid

      t.timestamps
    end
    add_index :user_companies, [:user_id, :company_id], unique: true
  end
end