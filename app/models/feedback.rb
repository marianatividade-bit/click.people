class Feedback < ApplicationRecord
  enum :visibility, { public_feedback: 0, private_feedback: 1 }

  belongs_to :giver,    class_name: "Person"
  belongs_to :receiver, class_name: "Person"
  belongs_to :cycle, optional: true

  validates :message, presence: true, length: { minimum: 10 }
  validate  :cannot_give_to_self

  private

  def cannot_give_to_self
    errors.add(:receiver, "não pode ser o mesmo que o remetente") if giver_id == receiver_id
  end
end
