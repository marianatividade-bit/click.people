class AddEvaluationTypeToEvaluations < ActiveRecord::Migration[8.1]
  def change
    add_column :evaluations, :evaluation_type, :integer, default: 0, null: false
    # 0=self, 1=chapter_manager, 2=stream_manager, 3=peer
    add_column :evaluations, :nomination_id, :integer
    add_column :evaluations, :completed_at, :datetime
  end
end
