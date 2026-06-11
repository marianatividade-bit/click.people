class PermissionCache < ApplicationRecord
  enum permission: {
    view_profile:    0,
    view_evaluation: 1,
    view_pdi:        2,
    view_score:      3,
    manage_evaluation: 4,
    manage_pdi:      5,
    manage_cycle:    6,
    view_dashboard:  7
  }

  belongs_to :viewer, class_name: "Person"
  belongs_to :target, class_name: "Person"

  def self.allowed?(viewer:, target:, permission:)
    exists?(viewer_id: viewer.id, target_id: target.id, permission: permission)
  end
end
