class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.references :evaluation, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.decimal :numeric_value, precision: 5, scale: 2
      t.text :text_value
      t.timestamps
    end
    add_index :answers, [:evaluation_id, :question_id], unique: true
  end
end
