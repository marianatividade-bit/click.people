class CyclesController < ApplicationController
  def index
    @cycles = Cycle.order(created_at: :desc)
  end

  def show
    @cycle = Cycle.find(params[:id])
  end

  def progress
    @cycle = Cycle.find(params[:id])
    total = Person.active.count
    return @completion = 0 if total.zero?

    submitted = Evaluation.where(cycle: @cycle, status: :submitted).select(:evaluator_id).distinct.count
    @completion = (submitted.to_f / total * 100).round
    @submitted_count = submitted
    @total_count = total
    @pending_people = Person.active
                            .where.not(id: Evaluation.where(cycle: @cycle, status: :submitted).select(:evaluator_id))
                            .order(:name)
  end

  def new
    @cycle = Cycle.new
  end

  def create
    @cycle = Cycle.new(cycle_params)
    if @cycle.save
      redirect_to cycles_path, notice: "Ciclo criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def cycle_params
    params.require(:cycle).permit(:name, :evaluation_deadline)
  end
end
