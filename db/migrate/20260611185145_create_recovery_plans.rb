class CreateRecoveryPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :recovery_plans do |t|
      t.references :person, null: false, foreign_key: true
      t.references :cycle, null: true, foreign_key: true
      t.integer :created_by_id
      t.string :title
      t.text :description
      t.text :reason
      t.json :actions
      t.integer :status
      t.date :due_date
      t.text :outcome

      t.timestamps
    end
  end
end
