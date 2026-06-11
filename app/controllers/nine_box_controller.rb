class NineBoxController < ApplicationController
  DEFAULT_CONFIG = {
    "quadrant_names" => [
      "Risco",            "Precisa Crescer",    "Potencial Oculto",
      "Em Desenvolvimento","Efetivo",            "Alto Desempenho",
      "Diamante Bruto",   "Estrela Emergente",  "Estrela"
    ],
    "axis_x_label" => "Desempenho",
    "axis_y_label" => "Potencial"
  }.freeze

  # /nine_box — redireciona para o ciclo mais recente
  def index
    cycle = Cycle.order(created_at: :desc).first
    if cycle
      redirect_to cycle_nine_box_path(cycle)
    else
      @no_cycle = true
      render :index
    end
  end

  # /cycles/:cycle_id/nine_box
  def show
    @cycle   = Cycle.find(params[:cycle_id])
    @config  = @cycle.nine_box_config.presence || DEFAULT_CONFIG
    @names   = @config["quadrant_names"] || DEFAULT_CONFIG["quadrant_names"]
    @axis_x  = @config["axis_x_label"]  || "Desempenho"
    @axis_y  = @config["axis_y_label"]  || "Potencial"

    # Agrupa pessoas por quadrante (quando CycleResult existir)
    # Por enquanto, monta o grid vazio
    @quadrants = Array.new(9) { [] }
  end

  def edit
    @cycle  = Cycle.find(params[:cycle_id])
    @config = @cycle.nine_box_config.presence || DEFAULT_CONFIG
    @names  = @config["quadrant_names"] || DEFAULT_CONFIG["quadrant_names"]
  end

  def update
    @cycle = Cycle.find(params[:cycle_id])
    cfg = params.require(:nine_box).permit(:axis_x_label, :axis_y_label, quadrant_names: [])

    new_config = {
      "axis_x_label"    => cfg[:axis_x_label].presence || "Desempenho",
      "axis_y_label"    => cfg[:axis_y_label].presence || "Potencial",
      "quadrant_names"  => cfg[:quadrant_names].first(9)
    }

    @cycle.update!(nine_box_config: new_config)
    redirect_to cycle_nine_box_path(@cycle), notice: "Configuração do 9-Box salva."
  end
end
