class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :update]

  def index
    @cycle = Cycle.order(created_at: :desc).first
    @evaluations = current_person.evaluations_given.includes(:evaluated, :cycle).order(created_at: :desc)
    @received = current_person.evaluations_received.submitted.includes(:evaluator, :cycle).order(submitted_at: :desc)
  end

  def new
    @cycles = Cycle.where(status: [:draft, :open, :evaluation]).order(created_at: :desc)
    @people = Person.where.not(id: current_person.id).order(:name)
    @evaluation = Evaluation.new(
      evaluator: current_person,
      cycle_id: params[:cycle_id],
      evaluated_id: params[:evaluated_id]
    )
  end

  def create
    @evaluation = Evaluation.new(evaluation_params.merge(evaluator: current_person))
    if @evaluation.save
      redirect_to evaluations_path, notice: "Avaliação salva como rascunho."
    else
      @cycles = Cycle.where(status: [:draft, :open, :evaluation]).order(created_at: :desc)
      @people = Person.where.not(id: current_person.id).order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def update
    if params[:submit]
      @evaluation.update(evaluation_params)
      @evaluation.submit!
      redirect_to evaluations_path, notice: "Avaliação enviada!"
    else
      if @evaluation.update(evaluation_params)
        redirect_to evaluation_path(@evaluation), notice: "Rascunho salvo."
      else
        render :show, status: :unprocessable_entity
      end
    end
  end

  private

  def set_evaluation
    @evaluation = current_person.evaluations_given.find(params[:id])
  end

  def evaluation_params
    params.require(:evaluation).permit(
      :cycle_id, :evaluated_id,
      :performance_score, :potential_score,
      :strengths, :improvements, :overall_comment
    )
  end
end
