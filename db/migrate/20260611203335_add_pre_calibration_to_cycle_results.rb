class AddPreCalibrationToCycleResults < ActiveRecord::Migration[8.1]
  def change
    add_column :cycle_results, :pre_calibration_position, :integer
    add_column :cycle_results, :pre_calibration_performance, :float
    add_column :cycle_results, :pre_calibration_potential, :float
    add_column :cycle_results, :is_calibrated, :boolean, default: false
  end
end
