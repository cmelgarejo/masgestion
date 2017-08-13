class CreateContactMeanTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_mean_types do |t|
      t.string :description, null: false, index: true

      t.timestamps
    end
  end
end
