class Nomination < ApplicationRecord
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  belongs_to :cycle
  belongs_to :evaluated, class_name: "Person"
  belongs_to :nominee,   class_name: "Person"
  belongs_to :validated_by, class_name: "Person", optional: true

  validates :cycle_id, uniqueness: { scope: [:evaluated_id, :nominee_id] }
  validate  :cannot_nominate_own_manager

  def approve!(by:)
    update!(status: :approved, validated_by: by, validated_at: Time.current)
  end

  def reject!(by:, reason: nil)
    update!(status: :rejected, validated_by: by, validated_at: Time.current, rejection_reason: reason)
  end

  private

  def cannot_nominate_own_manager
    if evaluated_id == nominee_id
      errors.add(:nominee, "não pode indicar a si mesmo")
    end
  end
end
