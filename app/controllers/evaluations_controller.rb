class EvaluationsController < ApplicationController
  def index
    # "My evaluations" dashboard
    @pending_as_evaluator = Evaluation.where(evaluator: current_person, cycle: active_cycles)
                                      .where(status: [:draft, :in_progress])
                                      .includes(:cycle, :evaluated)
                                      .order(:cycle_id)
    @completed_as_evaluator = Evaluation.where(evaluator: current_person)
                                        .where(status: :completed)
                                        .includes(:cycle, :evaluated)
                                        .order(completed_at: :desc)
                                        .limit(20)
    @being_evaluated = Evaluation.where(evaluated: current_person, cycle: active_cycles)
                                 .includes(:cycle, :evaluator)
                                 .order(:cycle_id)
  end

  def show
    @evaluation = Evaluation.find(params[:id])
    @questions  = @evaluation.cycle.questions.order(:position)
    @answers    = @evaluation.answers.index_by(&:question_id)
    authorize_evaluation!
  end

  def new
    # Direct-create an evaluation (admin use or re-entry)
    @cycle      = Cycle.find(params[:cycle_id])
    @evaluation = @cycle.evaluations.new(evaluator: current_person)
  end

  def create
    @cycle = Cycle.find(params[:cycle_id])
    @evaluation = @cycle.evaluations.find_or_initialize_by(
      evaluator: current_person,
      evaluated_id: params[:evaluated_id],
      evaluation_type: params[:evaluation_type]
    )
    if @evaluation.save
      redirect_to edit_evaluation_path(@evaluation)
    else
      redirect_to evaluations_path, alert: @evaluation.errors.full_messages.first
    end
  end

  def edit
    @evaluation = Evaluation.find(params[:id])
    @questions  = @evaluation.cycle.questions.order(:position)
    @answers    = @evaluation.answers.index_by(&:question_id)
    authorize_evaluation!
    @evaluation.update!(status: :in_progress) if @evaluation.draft?
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    authorize_evaluation!

    answers_data = params[:answers] || {}
    save_answers(@evaluation, answers_data)

    if params[:submit] == "complete"
      @evaluation.complete!
      redirect_to evaluations_path, notice: "Avaliação de #{@evaluation.evaluated.name} enviada com sucesso."
    else
      redirect_to edit_evaluation_path(@evaluation), notice: "Rascunho salvo."
    end
  end

  private

  def active_cycles
    Cycle.where(status: [:nominations_open, :validating, :evaluation_open, :calibration])
  end

  def authorize_evaluation!
    unless @evaluation.evaluator == current_person
      redirect_to evaluations_path, alert: "Você não tem permissão para acessar esta avaliação."
    end
  end

  def save_answers(evaluation, answers_data)
    answers_data.each do |question_id, value|
      question = Question.find_by(id: question_id)
      next unless question

      answer = evaluation.answers.find_or_initialize_by(question_id: question_id)
      if question.numeric?
        answer.numeric_value = value.presence
      else
        answer.text_value = value.presence
      end
      answer.save
    end
  end
end
