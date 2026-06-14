class CreateExperienceEvaluationTables < ActiveRecord::Migration[8.1]
  def change
    create_table :experience_evaluations do |t|
      t.integer  :person_id,             null: false   # colaborador avaliado
      t.integer  :evaluator_id                          # líder que avalia
      t.integer  :evaluation_type,       default: 0, null: false  # 0=days_20 1=days_70
      t.integer  :status,                default: 0, null: false  # 0=pending 1=in_progress 2=completed
      t.json     :collaborator_answers,  default: {}
      t.json     :leader_answers,        default: {}
      t.text     :rh_notes
      t.date     :due_date
      t.datetime :completed_at
      t.timestamps
      t.index [:person_id, :evaluation_type], unique: true
      t.index :status
    end

    create_table :experience_feedbacks do |t|
      t.integer  :person_id,       null: false   # colaborador
      t.integer  :leader_id,       null: false
      t.integer  :status,          default: 0, null: false  # 0=pending 1=scheduled 2=completed
      t.text     :public_notes
      t.text     :private_notes
      t.string   :calendar_event_id
      t.datetime :meeting_at
      t.datetime :completed_at
      t.timestamps
      t.index [:person_id], unique: true
    end

    add_foreign_key :experience_evaluations, :people, column: :person_id
    add_foreign_key :experience_evaluations, :people, column: :evaluator_id
    add_foreign_key :experience_feedbacks,   :people, column: :person_id
    add_foreign_key :experience_feedbacks,   :people, column: :leader_id
  end
end
