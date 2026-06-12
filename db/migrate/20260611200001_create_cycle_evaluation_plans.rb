class CreateCycleEvaluationPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :cycle_evaluation_plans do |t|
      t.references :cycle,     null: false, foreign_key: true
      t.references :evaluator, null: false, foreign_key: { to_table: :people }
      t.references :evaluated, null: false, foreign_key: { to_table: :people }
      t.integer    :evaluation_type, null: false, default: 0
      t.integer    :origin,          null: false, default: 0
      t.timestamps
    end

    add_index :cycle_evaluation_plans,
              %i[cycle_id evaluator_id evaluated_id],
              unique: true,
              name: "idx_eval_plan_unique"
  end
end
