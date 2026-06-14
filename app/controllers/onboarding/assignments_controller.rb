class Onboarding::AssignmentsController < ApplicationController
  before_action :set_trail

  def index
    redirect_to onboarding_trail_path(@trail)
  end

  def create
    person = Person.find(params[:person_id])
    assignment = @trail.assignments.find_or_initialize_by(person: person)
    assignment.assigned_by = current_person
    if assignment.save
      redirect_to onboarding_trail_path(@trail), notice: "#{person.name} adicionado(a) à trilha."
    else
      redirect_to onboarding_trail_path(@trail), alert: assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    assignment = @trail.assignments.find(params[:id])
    assignment.destroy
    redirect_to onboarding_trail_path(@trail), notice: "Pessoa removida da trilha."
  end

  def complete_step
    assignment = @trail.assignments.find(params[:id])
    unless assignment.person == current_person
      return redirect_to onboarding_trails_path, alert: "Acesso restrito."
    end

    step = OnboardingStep.find(params[:step_id])
    completion = assignment.step_completions.find_or_initialize_by(step: step)

    if completion.persisted?
      completion.destroy
      render json: { completed: false, progress: assignment.reload.progress_percent }
    else
      completion.save!
      render json: { completed: true, progress: assignment.reload.progress_percent }
    end
  end

  private

  def set_trail
    @trail = OnboardingTrail.find(params[:trail_id])
  end
end
