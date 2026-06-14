class ExperienceFeedback < ApplicationRecord
  belongs_to :person
  belongs_to :leader, class_name: "Person"

  enum :status, { pending: 0, scheduled: 1, completed: 2 }

  validates :person_id, uniqueness: { message: "já tem feedback de experiência" }

  def can_see_private_notes?(viewer)
    viewer.hr_admin? || viewer.business_partner? || viewer.id == leader_id
  end
end
