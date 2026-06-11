class CyclesController < ApplicationController
  def index
    @cycles = Cycle.order(created_at: :desc)
  end

  def show
    @cycle = Cycle.find(params[:id])
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
