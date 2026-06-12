class CycleEvaluationPlan < ApplicationRecord
  belongs_to :cycle
  belongs_to :evaluator, class_name: "Person"
  belongs_to :evaluated, class_name: "Person"

  enum :evaluation_type, {
    self_eval:       0,
    chapter_manager: 1,
    stream_manager:  2,
    peer:            3,
    direct_report:   4
  }
  enum :origin, { from_hierarchy: 0, manual: 1 }

  validates :evaluator_id, uniqueness: { scope: %i[cycle_id evaluated_id],
                                         message: "já avalia esta pessoa neste ciclo" }

  TYPE_LABELS = {
    "self_eval"       => "Auto-avaliação",
    "chapter_manager" => "Gestor de capítulo",
    "stream_manager"  => "Gestor de stream",
    "peer"            => "Par",
    "direct_report"   => "Liderado",
  }.freeze

  def type_label
    TYPE_LABELS[evaluation_type] || evaluation_type.humanize
  end

  def origin_label
    from_hierarchy? ? "Hierarquia" : "Manual"
  end

  def manager_type?
    chapter_manager? || stream_manager?
  end

  def other_type?
    direct_report? || peer?
  end
end
