class OnboardingStep < ApplicationRecord
  belongs_to :trail, class_name: "OnboardingTrail"
  has_many :completions, class_name: "OnboardingStepCompletion", foreign_key: :step_id, dependent: :destroy

  enum :step_type, { video: 0, task: 1, document: 2, link: 3 }

  validates :title, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(:position) }

  STEP_TYPE_LABELS = {
    "video"    => "Vídeo",
    "task"     => "Tarefa",
    "document" => "Documento",
    "link"     => "Link"
  }.freeze

  def type_label
    STEP_TYPE_LABELS[step_type] || step_type.humanize
  end
end
