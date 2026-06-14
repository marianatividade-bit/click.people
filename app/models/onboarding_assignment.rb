class OnboardingAssignment < ApplicationRecord
  belongs_to :person
  belongs_to :trail, class_name: "OnboardingTrail"
  belongs_to :assigned_by, class_name: "Person", optional: true
  has_many :step_completions, class_name: "OnboardingStepCompletion", foreign_key: :assignment_id, dependent: :destroy

  enum :status, { not_started: 0, in_progress: 1, completed: 2 }

  def completed_steps
    step_completions.count
  end

  def total_steps
    trail.steps.count
  end

  def progress_percent
    return 0 if total_steps.zero?
    (completed_steps.to_f / total_steps * 100).round
  end

  def step_completed?(step)
    step_completions.exists?(step_id: step.id)
  end
end
