class CycleEvaluationPlansController < ApplicationController
  before_action :authenticate_person!
  before_action :set_cycle
  before_action :require_hr_or_bp!

  # Adiciona uma única pessoa ao ciclo, auto-populando hierarquia
  def create
    evaluated = Person.find(params[:evaluated_id])
    auto_add_for_person(evaluated)
    @cycle.cycle_participants.find_or_create_by!(person: evaluated)
    redirect_to configure_cycle_path(@cycle, tab: "participantes"),
                notice: "#{evaluated.name} adicionado ao ciclo com gestores e liderados."
  end

  def destroy
    plan = @cycle.cycle_evaluation_plans.find(params[:id])
    plan.destroy!
    redirect_to configure_cycle_path(@cycle, tab: "participantes"), notice: "Avaliador removido."
  end

  # Remove todos os planos de uma pessoa avaliada (retira-a do ciclo)
  def remove_evaluated
    evaluated = Person.find(params[:evaluated_id])
    @cycle.cycle_evaluation_plans.where(evaluated: evaluated).destroy_all
    @cycle.cycle_participants.where(person: evaluated).destroy_all
    redirect_to configure_cycle_path(@cycle, tab: "participantes"),
                notice: "#{evaluated.name} removido do ciclo."
  end

  # Importa toda a hierarquia de uma vez
  def bulk_add
    Person.active.order(:name).each { |p| auto_add_for_person(p) }
    @cycle.cycle_participants.where.not(
      person_id: Person.active.pluck(:id)
    ).destroy_all
    Person.active.each { |p| @cycle.cycle_participants.find_or_create_by!(person: p) }

    redirect_to configure_cycle_path(@cycle, tab: "participantes"),
                notice: "Hierarquia importada com sucesso."
  end

  private

  def set_cycle
    @cycle = Cycle.find(params[:cycle_id])
  end

  def require_hr_or_bp!
    return if current_person.hr_admin? || current_person.business_partner?
    redirect_to root_path, alert: "Acesso restrito."
  end

  def auto_add_for_person(person)
    # Auto-avaliação
    upsert(:self_eval, person, person)

    # Gestores avaliam esta pessoa (downward)
    upsert(:chapter_manager, person.chapter_manager, person) if person.chapter_manager_id.present?
    upsert(:stream_manager,  person.stream_manager,  person) if person.stream_manager_id.present?

    # Liderados avaliam esta pessoa (upward)
    person.chapter_reports.active.each { |r| upsert(:direct_report, r, person) }
    person.stream_reports.active.each  { |r| upsert(:direct_report, r, person) }
  end

  def upsert(type, evaluator, evaluated)
    @cycle.cycle_evaluation_plans.find_or_create_by!(
      evaluator: evaluator,
      evaluated: evaluated
    ) do |p|
      p.evaluation_type = type
      p.origin = :from_hierarchy
    end
  end
end
