class CreateHistoryTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :history_types do |t|
      t.string :description

      t.timestamps
    end
  end
end
