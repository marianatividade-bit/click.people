class CreateCycles < ActiveRecord::Migration[8.1]
  def change
    create_table :cycles do |t|
      t.string   :name,                null: false
      t.integer  :status,              null: false, default: 0
      t.datetime :opened_at,           null: true
      t.date     :evaluation_deadline, null: true
      t.datetime :closed_at,           null: true
      t.json     :nine_box_config,     null: false, default: {}

      t.timestamps
    end

    add_index :cycles, :status
  end
end
