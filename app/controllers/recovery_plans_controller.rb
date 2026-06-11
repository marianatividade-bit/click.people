class RecoveryPlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update]
  before_action :require_manager_or_hr!, only: [:new, :create]
  before_action :require_access!, only: [:edit, :update]

  def index
    if current_person.hr_admin? || current_person.business_partner?
      @plans = RecoveryPlan.includes(:person, :created_by).order(created_at: :desc)
    elsif current_person.manager? || current_person.director?
      managed_ids = Person.where(chapter_manager_id: current_person.id)
                          .or(Person.where(stream_manager_id: current_person.id))
                          .pluck(:id)
      @plans = RecoveryPlan.where(person_id: managed_ids)
                           .or(RecoveryPlan.where(created_by_id: current_person.id))
                           .includes(:person, :created_by)
                           .order(created_at: :desc)
    else
      @plans = RecoveryPlan.where(person: current_person).includes(:created_by).order(created_at: :desc)
    end
  end

  def show; end

  def new
    @plan   = RecoveryPlan.new
    @people = Person.active.order(:name)
    @cycles = Cycle.order(created_at: :desc)
  end

  def create
    @plan = RecoveryPlan.new(plan_params)
    @plan.created_by = current_person
    @plan.actions ||= []

    if @plan.save
      redirect_to @plan, notice: "Plano de recuperação criado."
    else
      @people = Person.active.order(:name)
      @cycles = Cycle.order(created_at: :desc)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @people = Person.active.order(:name)
    @cycles = Cycle.order(created_at: :desc)
  end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: "Plano atualizado."
    else
      @people = Person.active.order(:name)
      @cycles = Cycle.order(created_at: :desc)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_plan
    @plan = RecoveryPlan.find(params[:id])
  end

  def require_manager_or_hr!
    unless current_person.manager? || current_person.director? ||
           current_person.hr_admin? || current_person.business_partner?
      redirect_to recovery_plans_path, alert: "Sem permissão."
    end
  end

  def require_access!
    unless @plan.created_by == current_person ||
           current_person.hr_admin? || current_person.business_partner?
      redirect_to @plan, alert: "Sem permissão."
    end
  end

  def plan_params
    params.require(:recovery_plan).permit(:person_id, :cycle_id, :title, :description,
                                          :reason, :status, :due_date, :outcome)
  end
end
