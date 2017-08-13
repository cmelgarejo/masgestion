class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :user, index: true #, foreign_key: true
      t.references :client, type: :uuid #, foreign_key: true, index: true
      t.references :task_category
      t.string :name, null: false
      t.date :due

      t.timestamps
    end
    add_index :tasks, [:user_id, :client_id]
  end
end
