class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :person, null: false, foreign_key: true
      t.string     :title,  null: false
      t.text       :body
      t.string     :link
      t.datetime   :read_at
      t.timestamps
    end
    add_index :notifications, [:person_id, :read_at]
  end
end
