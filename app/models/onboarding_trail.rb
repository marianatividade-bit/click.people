class OnboardingTrail < ApplicationRecord
  belongs_to :created_by, class_name: "Person", optional: true
  has_many :steps, class_name: "OnboardingStep", foreign_key: :trail_id, dependent: :destroy
  has_many :assignments, class_name: "OnboardingAssignment", foreign_key: :trail_id, dependent: :destroy

  validates :name, presence: true

  scope :active, -> { where(active: true) }

  def completion_rate
    return 0 if assignments.empty?
    assignments.where(status: :completed).count.to_f / assignments.count * 100
  end
end
