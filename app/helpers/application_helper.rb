module ApplicationHelper
  STATUS_LABELS = {
    "draft"       => "Rascunho",
    "open"        => "Aberto",
    "evaluation"  => "Avaliação",
    "calibration" => "Calibração",
    "closed"      => "Encerrado"
  }.freeze

  def t_status(status)
    STATUS_LABELS[status.to_s] || status.to_s.humanize
  end
end
