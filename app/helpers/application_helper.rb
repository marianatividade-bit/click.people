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

  def person_avatar(person, size: 40, font_size: nil)
    fs = font_size || (size / 2.5).round
    if person.photo.attached?
      image_tag(person.photo, style: "width:#{size}px;height:#{size}px;border-radius:50%;object-fit:cover;flex-shrink:0;")
    else
      initials = person.name.split.first(2).map { |w| w[0].upcase }.join
      content_tag(:div, initials,
        style: "width:#{size}px;height:#{size}px;border-radius:50%;background:var(--color-accent);color:#fff;font-size:#{fs}px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;")
    end
  end
end
