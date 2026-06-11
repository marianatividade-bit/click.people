class Person < ApplicationRecord
  enum role: { employee: 0, manager: 1, director: 2, hr_admin: 3, business_partner: 4 }
  enum status: { active: 0, inactive: 1 }

  belongs_to :chapter_manager, class_name: "Person", optional: true
  belongs_to :stream_manager,  class_name: "Person", optional: true

  has_many :chapter_reports, class_name: "Person", foreign_key: :chapter_manager_id
  has_many :stream_reports,  class_name: "Person", foreign_key: :stream_manager_id

  has_many :evaluations_given,    class_name: "Evaluation", foreign_key: :evaluator_id
  has_many :evaluations_received, class_name: "Evaluation", foreign_key: :evaluated_id
  has_many :cycle_results
  has_many :pdis
  has_many :recovery_plans
  has_many :feedbacks_given,    class_name: "Feedback", foreign_key: :giver_id
  has_many :feedbacks_received, class_name: "Feedback", foreign_key: :receiver_id
  has_many :notifications
  has_many :permission_caches_as_viewer, class_name: "PermissionCache", foreign_key: :viewer_id
  has_many :permission_caches_as_target, class_name: "PermissionCache", foreign_key: :target_id

  validates :name,       presence: true
  validates :email,      presence: true, uniqueness: true
  validates :google_uid, presence: true, uniqueness: true

  after_update :enqueue_permission_cache_rebuild, if: :org_changed?

  private

  def org_changed?
    saved_change_to_chapter_manager_id? || saved_change_to_stream_manager_id?
  end

  def enqueue_permission_cache_rebuild
    touch(:org_updated_at)
    PermissionCacheRebuildJob.perform_later(id)
  end
end
