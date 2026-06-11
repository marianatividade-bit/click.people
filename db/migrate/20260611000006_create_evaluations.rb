class CreateEvaluations < ActiveRecord::Migration[8.1]
  def change
    create_table :evaluations do |t|
      t.references :cycle,     null: false, foreign_key: true
      t.references :evaluator, null: false, foreign_key: { to_table: :people }
      t.references :evaluated, null: false, foreign_key: { to_table: :people }
      t.integer    :status,    null: false, default: 0
      t.float      :performance_score
      t.float      :potential_score
      t.text       :strengths
      t.text       :improvements
      t.text       :overall_comment
      t.datetime   :submitted_at

      t.timestamps
    end

    add_index :evaluations, [:cycle_id, :evaluator_id, :evaluated_id], unique: true, name: "idx_evaluations_unique"
    add_index :evaluations, :status
  end
end
