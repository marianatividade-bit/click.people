class Question < ApplicationRecord
  DIMENSIONS = %w[resultado atitude open next_steps].freeze

  enum :answer_type, { numeric: 0, text: 1 }

  belongs_to :cycle
  has_many :answers, dependent: :destroy

  validates :text, :dimension, presence: true
  validates :dimension, inclusion: { in: DIMENSIONS }
  validates :min_score, :max_score, presence: true, if: :numeric?
  validates :max_score, numericality: { greater_than: :min_score }, if: :numeric?

  def dimension_label
    case dimension
    when "resultado"   then "Resultado"
    when "atitude"     then "Atitude"
    when "open"        then "Pergunta aberta"
    when "next_steps"  then "Próximos passos"
    end
  end
end
