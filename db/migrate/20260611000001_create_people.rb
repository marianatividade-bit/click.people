class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.string  :name,       null: false
      t.string  :email,      null: false
      t.string  :google_uid, null: false

      t.references :chapter_manager, foreign_key: { to_table: :people }, null: true
      t.references :stream_manager,  foreign_key: { to_table: :people }, null: true

      t.integer :role,   null: false, default: 0
      t.integer :status, null: false, default: 0

      t.date     :offboarded_at,  null: true
      t.datetime :org_updated_at, null: true

      t.timestamps
    end

    add_index :people, :email,      unique: true
    add_index :people, :google_uid, unique: true
  end
end
