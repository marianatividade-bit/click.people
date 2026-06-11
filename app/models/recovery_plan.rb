class RecoveryPlan < ApplicationRecord
  enum :status, { active: 0, completed: 1, cancelled: 2 }

  belongs_to :person
  belongs_to :cycle, optional: true
  belongs_to :created_by, class_name: "Person", foreign_key: :created_by_id

  validates :title, :reason, presence: true

  def progress_percent
    return 0 if actions.blank?
    done = actions.count { |a| a["done"] }
    (done.to_f / actions.size * 100).round
  end
end
