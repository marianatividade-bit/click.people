class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :cycle, null: false, foreign_key: true
      t.string :dimension, null: false  # resultado / atitude / open / next_steps
      t.text :text, null: false
      t.integer :answer_type, default: 0, null: false  # 0=numeric, 1=text
      t.integer :min_score, default: 1
      t.integer :max_score, default: 10
      t.decimal :weight, default: 1.0, precision: 4, scale: 2
      t.string :evaluator_types, default: "all"  # all / manager_only
      t.integer :position, default: 0
      t.timestamps
    end
  end
end
