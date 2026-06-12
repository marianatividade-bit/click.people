class ExpandCyclesForPerformanceManagement < ActiveRecord::Migration[8.1]
  def change
    add_column :cycles, :description, :text
    add_column :cycles, :created_by_id, :integer
    add_column :cycles, :max_peer_nominations, :integer, default: 5, null: false
    add_column :cycles, :nominations_start, :datetime
    add_column :cycles, :nominations_end, :datetime
    add_column :cycles, :validations_start, :datetime
    add_column :cycles, :validations_end, :datetime
    add_column :cycles, :evaluation_start, :datetime
    add_column :cycles, :evaluation_end, :datetime
    add_column :cycles, :calibration_start, :datetime
    add_column :cycles, :calibration_end, :datetime
  end
end
