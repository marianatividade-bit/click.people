class Evaluation < ApplicationRecord
  enum :status, { draft: 0, in_progress: 1, completed: 2, expired: 3 }
  enum :evaluation_type, { self_eval: 0, chapter_manager: 1, stream_manager: 2, peer: 3 }

  belongs_to :cycle
  belongs_to :evaluator, class_name: "Person"
  belongs_to :evaluated, class_name: "Person"
  belongs_to :nomination, optional: true
  has_many :answers, dependent: :destroy

  scope :for_evaluated, ->(person) { where(evaluated: person) }
  scope :submitted,     -> { where(status: :completed) }

  validates :evaluator_id, uniqueness: { scope: [:cycle_id, :evaluated_id, :evaluation_type] }

  def complete!
    update!(status: :completed, completed_at: Time.current)
  end

  def type_label
    case evaluation_type
    when "self_eval"        then "Autoavaliação"
    when "chapter_manager"  then "Gestor de Chapter"
    when "stream_manager"   then "Gestor de Stream"
    when "peer"             then "Par"
    end
  end
end
