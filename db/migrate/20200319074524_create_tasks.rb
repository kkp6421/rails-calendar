class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :text
      t.datetime :selected_date
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :tasks, [:user_id, :created_at]
  end
end
