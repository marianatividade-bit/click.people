class CycleParticipant < ApplicationRecord
  enum :status, { pending: 0, completed: 1 }

  belongs_to :cycle
  belongs_to :person

  validates :cycle_id, uniqueness: { scope: :person_id }
end
