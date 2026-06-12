class NominationsController < ApplicationController
  before_action :set_cycle

  def index
    @my_nominations = @cycle.nominations.where(evaluated: current_person).includes(:nominee)
    @max = @cycle.max_peer_nominations
    @all_people = Person.active.where.not(id: current_person.id).order(:name)
    @can_nominate = @cycle.nominations_open? && @cycle.cycle_participants.exists?(person: current_person)
  end

  def create
    existing = @cycle.nominations.where(evaluated: current_person).count
    max = @cycle.max_peer_nominations

    if existing >= max
      redirect_to cycle_nominations_path(@cycle), alert: "Você atingiu o limite de #{max} indicações."
      return
    end

    nominee = Person.find(params[:nominee_id])
    nomination = @cycle.nominations.find_or_initialize_by(evaluated: current_person, nominee: nominee)

    if nomination.new_record?
      nomination.save!
      redirect_to cycle_nominations_path(@cycle), notice: "#{nominee.name} indicado(a) com sucesso."
    else
      redirect_to cycle_nominations_path(@cycle), alert: "Você já indicou #{nominee.name}."
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to cycle_nominations_path(@cycle), alert: e.message
  end

  def destroy
    nomination = @cycle.nominations.find_by(id: params[:id], evaluated: current_person)
    if nomination&.pending?
      nomination.destroy
      redirect_to cycle_nominations_path(@cycle), notice: "Indicação removida."
    else
      redirect_to cycle_nominations_path(@cycle), alert: "Não é possível remover esta indicação."
    end
  end

  # Manager validates nominations for their direct reports
  def validate_index
    # Nominations for people this manager leads (chapter or stream)
    my_team_ids = Person.where(chapter_manager: current_person)
                        .or(Person.where(stream_manager: current_person))
                        .pluck(:id)
    @pending_nominations = @cycle.nominations
                                 .where(evaluated_id: my_team_ids, status: :pending)
                                 .includes(:evaluated, :nominee)
    @all_nominations = @cycle.nominations
                             .where(evaluated_id: my_team_ids)
                             .includes(:evaluated, :nominee)
                             .order(:evaluated_id, :status)
  end

  def approve
    nomination = @cycle.nominations.find(params[:id])
    nomination.approve!(by: current_person)
    redirect_back fallback_location: validate_index_cycle_nominations_path(@cycle),
                  notice: "Indicação de #{nomination.nominee.name} aprovada."
  end

  def reject
    nomination = @cycle.nominations.find(params[:id])
    nomination.reject!(by: current_person, reason: params[:rejection_reason])
    redirect_back fallback_location: validate_index_cycle_nominations_path(@cycle),
                  notice: "Indicação de #{nomination.nominee.name} rejeitada."
  end

  private

  def set_cycle
    @cycle = Cycle.find(params[:cycle_id])
  end
end
