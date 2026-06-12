class CreateCycleParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :cycle_participants do |t|
      t.references :cycle, null: false, foreign_key: true
      t.integer :person_id, null: false
      t.integer :status, default: 0, null: false  # 0=pending, 1=completed
      t.timestamps
    end
    add_index :cycle_participants, [:cycle_id, :person_id], unique: true
  end
end
