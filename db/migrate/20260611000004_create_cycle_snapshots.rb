class CreateCycleSnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :cycle_snapshots do |t|
      t.references :cycle,           null: false, foreign_key: true
      t.references :person,          null: false, foreign_key: true
      t.references :chapter_manager, null: true,  foreign_key: { to_table: :people }
      t.references :stream_manager,  null: true,  foreign_key: { to_table: :people }

      t.datetime :created_at, null: false
      # Sem updated_at — imutável por design
    end

    add_index :cycle_snapshots, [:cycle_id, :person_id], unique: true
  end
end
