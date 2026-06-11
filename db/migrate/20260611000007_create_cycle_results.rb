class CreateCycleResults < ActiveRecord::Migration[8.1]
  def change
    create_table :cycle_results do |t|
      t.references :cycle,  null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.integer    :nine_box_position
      t.float      :performance_score
      t.float      :potential_score
      t.text       :calibration_notes
      t.integer    :calibrated_by_id
      t.datetime   :calibrated_at
      t.timestamps
    end
    add_index :cycle_results, [:cycle_id, :person_id], unique: true
  end
end
