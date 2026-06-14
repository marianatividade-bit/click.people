class CreateOnboardingTables < ActiveRecord::Migration[8.1]
  def change
    create_table :onboarding_trails do |t|
      t.string  :name,        null: false
      t.text    :description
      t.integer :created_by_id
      t.boolean :active,      default: true, null: false
      t.timestamps
    end

    create_table :onboarding_steps do |t|
      t.integer :trail_id,    null: false
      t.string  :title,       null: false
      t.text    :description
      t.integer :step_type,   default: 0, null: false  # 0=video 1=task 2=document 3=link
      t.string  :content_url
      t.integer :position,    default: 0, null: false
      t.boolean :required,    default: true, null: false
      t.timestamps
      t.index :trail_id
    end

    create_table :onboarding_assignments do |t|
      t.integer  :person_id,      null: false
      t.integer  :trail_id,       null: false
      t.integer  :assigned_by_id
      t.integer  :status,         default: 0, null: false  # 0=not_started 1=in_progress 2=completed
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps
      t.index [:person_id, :trail_id], unique: true
    end

    create_table :onboarding_step_completions do |t|
      t.integer  :assignment_id, null: false
      t.integer  :step_id,       null: false
      t.datetime :completed_at
      t.timestamps
      t.index [:assignment_id, :step_id], unique: true
    end

    add_foreign_key :onboarding_steps,           :onboarding_trails, column: :trail_id
    add_foreign_key :onboarding_assignments,      :onboarding_trails, column: :trail_id
    add_foreign_key :onboarding_assignments,      :people,            column: :person_id
    add_foreign_key :onboarding_step_completions, :onboarding_assignments, column: :assignment_id
    add_foreign_key :onboarding_step_completions, :onboarding_steps,       column: :step_id
  end
end
