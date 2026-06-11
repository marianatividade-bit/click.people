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
end
