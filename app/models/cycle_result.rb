class CycleResult < ApplicationRecord
  belongs_to :cycle
  belongs_to :person
  belongs_to :calibrated_by, class_name: "Person", optional: true, foreign_key: :calibrated_by_id

  validates :cycle, :person, presence: true
  validates :nine_box_position, inclusion: { in: 0..8 }, allow_nil: true

  scope :positioned, -> { where.not(nine_box_position: nil) }
end
