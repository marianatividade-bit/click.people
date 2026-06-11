class Cycle < ApplicationRecord
  enum :status, { draft: 0, open: 1, evaluation: 2, calibration: 3, closed: 4 }

  has_many :cycle_snapshots
  has_many :evaluations
  has_many :cycle_results
  has_many :pdis

  validates :name, presence: true
  validate  :nine_box_config_valid, if: -> { nine_box_config.present? }

  def open!
    transaction do
      update!(status: :open, opened_at: Time.current)
      CycleSnapshotJob.perform_later(id)
    end
  end

  def close!
    transaction do
      update!(status: :closed, closed_at: Time.current)
      evaluations.draft.update_all(status: :expired)
      CycleResultComputeJob.perform_later(id)
    end
  end

  private

  def nine_box_config_valid
    cfg = nine_box_config
    errors.add(:nine_box_config, "must have 9 quadrant_names") unless cfg["quadrant_names"]&.size == 9
    errors.add(:nine_box_config, "must have 2 axis_x_thresholds") unless cfg["axis_x_thresholds"]&.size == 2
    errors.add(:nine_box_config, "must have 2 axis_y_thresholds") unless cfg["axis_y_thresholds"]&.size == 2
    errors.add(:nine_box_config, "evaluator_weights must sum to 1.0") unless weights_sum_to_one?(cfg)
  end

  def weights_sum_to_one?(cfg)
    weights = cfg.dig("evaluator_weights")&.values&.sum.to_f
    (weights - 1.0).abs < 0.01
  end
end
