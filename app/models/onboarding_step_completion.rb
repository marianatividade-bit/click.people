class OnboardingStepCompletion < ApplicationRecord
  belongs_to :assignment, class_name: "OnboardingAssignment"
  belongs_to :step, class_name: "OnboardingStep"

  before_create :set_completed_at
  after_create  :update_assignment_status
  after_destroy :update_assignment_status

  private

  def set_completed_at
    self.completed_at ||= Time.current
  end

  def update_assignment_status
    total   = assignment.trail.steps.count
    done    = assignment.step_completions.count
    if done.zero?
      assignment.not_started!
    elsif done >= total
      assignment.update!(status: :completed, completed_at: Time.current)
    else
      assignment.in_progress! unless assignment.in_progress?
    end
  end
end
