class NineBoxController < ApplicationController
  def index
    # Global 9-box across all closed cycles
    @cycles = Cycle.where(status: :closed).order(created_at: :desc)
    @cycle  = @cycles.first
    redirect_to cycle_nine_box_path(@cycle) if @cycle
  end

  def show
    @cycle   = Cycle.find(params[:cycle_id])
    @results = @cycle.cycle_results.includes(:person).where.not(nine_box_position: nil)
    @cfg     = @cycle.nine_box_config.presence || {}
    @quadrant_labels = default_quadrant_labels
    @can_calibrate   = current_person.hr_admin? || current_person.business_partner?
  end

  def edit
    @cycle   = Cycle.find(params[:cycle_id])
    @results = @cycle.cycle_results.includes(:person).where.not(nine_box_position: nil)
    @cfg     = @cycle.nine_box_config.presence || {}
    @quadrant_labels = default_quadrant_labels
  end

  def update
    @cycle  = Cycle.find(params[:cycle_id])
    result  = @cycle.cycle_results.find(params[:result_id])
    new_pos = params[:nine_box_position].to_i

    result.update!(
      nine_box_position:  new_pos,
      is_calibrated:      true,
      calibrated_by:      current_person,
      calibrated_at:      Time.current,
      calibration_notes:  params[:calibration_notes]
    )

    redirect_to edit_cycle_nine_box_path(@cycle), notice: "Posição de #{result.person.name} atualizada."
  end

  private

  def default_quadrant_labels
    [
      "Baixo desempenho",    "Em desenvolvimento",   "Talento emergente",
      "Contribuidor sólido", "Core talent",           "Alto potencial",
      "Especialista valioso","Referência",            "Estrela"
    ]
  end
end
