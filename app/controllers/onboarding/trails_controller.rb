class Onboarding::TrailsController < ApplicationController
  before_action :require_admin!, only: [:new, :create, :edit, :update]
  before_action :set_trail, only: [:show, :edit, :update]

  def index
    if current_person.hr_admin? || current_person.business_partner?
      @trails = OnboardingTrail.includes(:steps, :assignments).order(:name)
    else
      @assignment = OnboardingAssignment.includes(trail: :steps, step_completions: :step)
                                        .find_by(person: current_person)
    end
  end

  def show
    @steps = @trail.steps
    @assignments = @trail.assignments.includes(:person).order("people.name") if admin?
    @my_assignment = @trail.assignments.find_by(person: current_person)
  end

  def new
    @trail = OnboardingTrail.new
  end

  def create
    @trail = OnboardingTrail.new(trail_params)
    @trail.created_by = current_person
    if @trail.save
      redirect_to onboarding_trail_path(@trail), notice: "Trilha criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @trail.update(trail_params)
      redirect_to onboarding_trail_path(@trail), notice: "Trilha atualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_trail
    @trail = OnboardingTrail.find(params[:id])
  end

  def trail_params
    params.require(:onboarding_trail).permit(:name, :description, :active)
  end

  def require_admin!
    redirect_to onboarding_trails_path, alert: "Acesso restrito." unless admin?
  end

  def admin?
    current_person.hr_admin? || current_person.business_partner?
  end
end
