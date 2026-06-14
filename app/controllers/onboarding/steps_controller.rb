class Onboarding::StepsController < ApplicationController
  before_action :require_admin!
  before_action :set_trail, only: [:create]
  before_action :set_step, only: [:update, :destroy, :reorder]

  def create
    @step = @trail.steps.build(step_params)
    @step.position = @trail.steps.maximum(:position).to_i + 1
    if @step.save
      redirect_to onboarding_trail_path(@trail), notice: "Passo adicionado."
    else
      redirect_to onboarding_trail_path(@trail), alert: @step.errors.full_messages.to_sentence
    end
  end

  def update
    if @step.update(step_params)
      redirect_to onboarding_trail_path(@step.trail), notice: "Passo atualizado."
    else
      redirect_to onboarding_trail_path(@step.trail), alert: @step.errors.full_messages.to_sentence
    end
  end

  def destroy
    trail = @step.trail
    @step.destroy
    redirect_to onboarding_trail_path(trail), notice: "Passo removido."
  end

  def reorder
    @step.update(position: params[:position].to_i)
    head :ok
  end

  private

  def set_trail
    @trail = OnboardingTrail.find(params[:trail_id])
  end

  def set_step
    @step = OnboardingStep.find(params[:id])
  end

  def step_params
    params.require(:onboarding_step).permit(:title, :description, :step_type, :content_url, :required)
  end

  def require_admin!
    redirect_to onboarding_trails_path, alert: "Acesso restrito." unless
      current_person.hr_admin? || current_person.business_partner?
  end
end
