class Onboarding::EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update]

  def create
    @evaluation = ExperienceEvaluation.new(
      person_id:       params.dig(:experience_evaluation, :person_id),
      evaluator_id:    params.dig(:experience_evaluation, :evaluator_id).presence,
      evaluation_type: params.dig(:experience_evaluation, :evaluation_type),
      due_date:        params.dig(:experience_evaluation, :due_date).presence
    )
    if @evaluation.save
      redirect_to onboarding_evaluations_path, notice: "Avaliação criada com sucesso."
    else
      redirect_to onboarding_evaluations_path, alert: @evaluation.errors.full_messages.to_sentence
    end
  end

  def index
    if current_person.hr_admin? || current_person.business_partner?
      @evaluations = ExperienceEvaluation.includes(:person, :evaluator).order(created_at: :desc)
    elsif current_person.manager?
      led_ids = Person.where(chapter_manager_id: current_person.id)
                      .or(Person.where(stream_manager_id: current_person.id)).pluck(:id)
      @evaluations = ExperienceEvaluation.where(person_id: led_ids)
                                         .or(ExperienceEvaluation.where(evaluator_id: current_person.id))
                                         .includes(:person, :evaluator)
    else
      @evaluations = ExperienceEvaluation.where(person: current_person)
                                         .or(ExperienceEvaluation.where(evaluator: current_person))
                                         .includes(:person, :evaluator)
    end
    @my_evaluations = @evaluations.select { |e| e.person_id == current_person.id }
    @to_fill        = @evaluations.select { |e| e.evaluator_id == current_person.id && !e.completed? }
  end

  def show; end

  def edit
    unless can_fill?
      redirect_to onboarding_evaluations_path, alert: "Você não pode editar esta avaliação."
    end
  end

  def update
    answers_key = leader_filling? ? :leader_answers : :collaborator_answers
    merged = @evaluation.send(answers_key).merge(answers_params)

    if @evaluation.update(answers_key => merged)
      if @evaluation.both_complete?
        @evaluation.update(status: :completed, completed_at: Time.current)
      elsif @evaluation.status == "pending"
        @evaluation.in_progress!
      end
      redirect_to onboarding_evaluation_path(@evaluation), notice: "Respostas salvas."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_evaluation
    @evaluation = ExperienceEvaluation.find(params[:id])
  end

  def can_fill?
    @evaluation.person == current_person || @evaluation.evaluator == current_person ||
      current_person.hr_admin? || current_person.business_partner?
  end

  def leader_filling?
    @evaluation.evaluator == current_person
  end

  def answers_params
    params.require(:answers).permit!.to_h
  end
end
