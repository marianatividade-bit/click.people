class Answer < ApplicationRecord
  belongs_to :evaluation
  belongs_to :question

  validates :evaluation_id, uniqueness: { scope: :question_id }
  validates :numeric_value, presence: true, if: -> { question&.numeric? }
  validates :text_value,    presence: true, if: -> { question&.text? }
  validates :numeric_value,
    numericality: { greater_than_or_equal_to: ->(a) { a.question&.min_score.to_f },
                    less_than_or_equal_to:    ->(a) { a.question&.max_score.to_f } },
    if: -> { question&.numeric? && numeric_value.present? }
end
