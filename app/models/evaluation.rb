class Evaluation < ApplicationRecord
  enum :status, { draft: 0, submitted: 1, expired: 2 }

  belongs_to :cycle
  belongs_to :evaluator, class_name: "Person"
  belongs_to :evaluated, class_name: "Person"

  validates :evaluator, :evaluated, :cycle, presence: true
  validate  :cannot_evaluate_self

  scope :for_evaluator, ->(person) { where(evaluator: person) }
  scope :for_evaluated, ->(person) { where(evaluated: person) }

  def submit!
    update!(status: :submitted, submitted_at: Time.current)
  end

  private

  def cannot_evaluate_self
    errors.add(:evaluated, "não pode ser o mesmo que o avaliador") if evaluator_id == evaluated_id
  end
end
