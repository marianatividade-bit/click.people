class CyclesController < ApplicationController
  before_action :set_cycle, only: [:show, :update, :configure, :update_configure, :advance, :progress, :destroy, :duplicate]

  def index
    @cycles = Cycle.order(created_at: :desc)
  end

  def show
    @stats = {
      participants: @cycle.cycle_participants.count,
      questions:    @cycle.questions.count,
      nominations:  @cycle.nominations.count,
      evaluations:  @cycle.evaluations.count,
      completed:    @cycle.evaluations.where(status: :completed).count,
    }
  end

  def new
    @cycle = Cycle.new
  end

  def create
    @cycle = Cycle.new(cycle_params)
    @cycle.created_by = current_person
    if @cycle.save
      redirect_to configure_cycle_path(@cycle), notice: "Ciclo criado. Configure as etapas antes de abrir."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @cycle.update(cycle_update_params)
      redirect_to @cycle, notice: "Ciclo atualizado."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def configure
    @questions = @cycle.questions.order(:position)
    @participants = @cycle.cycle_participants.includes(:person).map(&:person)
    @all_people = Person.active.order(:name)
    @tab = params[:tab] || "geral"

    if @tab == "participantes"
      plans = @cycle.cycle_evaluation_plans.includes(:evaluator, :evaluated)

      # Group plans by the evaluated person's id
      @plans_by_evaluated = plans.group_by(&:evaluated_id)

      # Evaluated people sorted by name
      evaluated_ids = @plans_by_evaluated.keys
      @evaluated_people = Person.where(id: evaluated_ids).order(:name)

      # People not yet in this cycle (for the add form)
      @people_not_in_cycle = Person.active.where.not(id: evaluated_ids).order(:name)

      # Approved nominations grouped by the nominator (= the evaluated person)
      @nominations_by_nominator = @cycle.nominations
                                        .where(status: :approved)
                                        .includes(:nominated)
                                        .group_by(&:nominator_id)
    end
  end

  def update_configure
    tab = params[:tab] || "geral"
    success = case tab
              when "geral"        then @cycle.update(geral_params)
              when "cronograma"   then @cycle.update(cronograma_params)
              when "nine_box"     then @cycle.update(nine_box_params_hash)
              when "participantes"
                sync_participants(params[:person_ids])
                true
              else
                false
              end
    if success
      redirect_to configure_cycle_path(@cycle, tab: tab), notice: "Configuração salva."
    else
      @questions    = @cycle.questions.order(:position)
      @participants = @cycle.cycle_participants.includes(:person).map(&:person)
      @all_people   = Person.active.order(:name)
      @tab          = tab
      render :configure, status: :unprocessable_entity
    end
  end

  def advance
    next_status = {
      "draft"            => :nominations_open,
      "nominations_open" => :validating,
      "validating"       => :evaluation_open,
      "evaluation_open"  => :calibration,
      "calibration"      => :closed,
    }[@cycle.status]

    if next_status
      @cycle.update!(status: next_status)
      @cycle.generate_evaluation_assignments! if next_status == :evaluation_open
      @cycle.compute_results!                 if next_status == :calibration
      redirect_to @cycle, notice: "Ciclo avançado para: #{@cycle.current_phase_label}"
    else
      redirect_to @cycle, alert: "Ciclo já está encerrado."
    end
  end

  def progress
    total     = @cycle.cycle_participants.count
    completed = @cycle.evaluations.where(status: :completed).count
    total_evals = @cycle.evaluations.count
    @completion = total_evals > 0 ? (completed.to_f / total_evals * 100).round : 0
    @submitted_count = completed
    @total_count     = total_evals
    @pending_people  = Person.active
                             .where.not(id: @cycle.evaluations.where(status: :completed).select(:evaluator_id))
                             .order(:name)
  end

  def duplicate
    original = @cycle
    copy = original.dup
    copy.name   = "#{original.name} (cópia)"
    copy.status = :draft
    copy.opened_at = nil
    copy.closed_at = nil
    copy.save!

    original.questions.each do |q|
      new_q = q.dup
      new_q.cycle = copy
      new_q.save!
    end

    redirect_to configure_cycle_path(copy), notice: "Ciclo duplicado com sucesso. Configure as novas datas."
  end

  def destroy
    if @cycle.draft?
      @cycle.destroy
      redirect_to cycles_path, notice: "Ciclo excluído."
    else
      redirect_to @cycle, alert: "Só é possível excluir ciclos em rascunho."
    end
  end

  private

  def set_cycle
    @cycle = Cycle.find(params[:id])
  end

  def cycle_params
    params.require(:cycle).permit(:name, :description)
  end

  def cycle_update_params
    params.require(:cycle).permit(:name, :description, :max_peer_nominations)
  end

  def geral_params
    params.require(:cycle).permit(:name, :description, :max_peer_nominations)
  end

  def cronograma_params
    params.require(:cycle).permit(
      :nominations_start, :nominations_end,
      :validations_start, :validations_end,
      :evaluation_start,  :evaluation_end,
      :calibration_start, :calibration_end
    )
  end

  def nine_box_params_hash
    cfg = params[:nine_box] || {}
    {
      nine_box_config: {
        "axis_x_label"        => cfg[:axis_x_label],
        "axis_y_label"        => cfg[:axis_y_label],
        "axis_x_thresholds"   => [cfg[:x_low].to_f, cfg[:x_high].to_f],
        "axis_y_thresholds"   => [cfg[:y_low].to_f, cfg[:y_high].to_f],
      }
    }
  end

  def sync_participants(person_ids)
    ids = Array(person_ids).map(&:to_i).select(&:positive?)
    existing = @cycle.cycle_participants.pluck(:person_id)
    to_add    = ids - existing
    to_remove = existing - ids
    CycleParticipant.where(cycle: @cycle, person_id: to_remove).destroy_all
    to_add.each { |pid| CycleParticipant.create!(cycle: @cycle, person_id: pid) }
  end
end
