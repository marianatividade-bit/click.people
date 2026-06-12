class CreateNominations < ActiveRecord::Migration[8.1]
  def change
    create_table :nominations do |t|
      t.references :cycle, null: false, foreign_key: true
      t.integer :evaluated_id, null: false   # person being evaluated
      t.integer :nominee_id, null: false     # peer nominated to evaluate
      t.integer :status, default: 0, null: false  # 0=pending, 1=approved, 2=rejected
      t.integer :validated_by_id
      t.datetime :validated_at
      t.text :rejection_reason
      t.timestamps
    end
    add_index :nominations, [:cycle_id, :evaluated_id, :nominee_id], unique: true
  end
end
