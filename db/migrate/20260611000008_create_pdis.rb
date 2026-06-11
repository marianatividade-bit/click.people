class CreatePdis < ActiveRecord::Migration[8.1]
  def change
    create_table :pdis do |t|
      t.references :person, null: false, foreign_key: true
      t.references :cycle,  null: true,  foreign_key: true
      t.string     :title,  null: false
      t.text       :description
      t.integer    :status, null: false, default: 0
      t.date       :due_date
      t.json       :actions, null: false, default: []
      t.timestamps
    end
    add_index :pdis, :status
  end
end
