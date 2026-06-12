class QuestionsController < ApplicationController
  before_action :set_cycle

  def create
    @question = @cycle.questions.build(question_params)
    @question.position = @cycle.questions.maximum(:position).to_i + 1
    if @question.save
      redirect_to configure_cycle_path(@cycle, tab: "perguntas"), notice: "Pergunta adicionada."
    else
      redirect_to configure_cycle_path(@cycle, tab: "perguntas"), alert: @question.errors.full_messages.first
    end
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to configure_cycle_path(@cycle, tab: "perguntas"), notice: "Pergunta atualizada."
    else
      redirect_to configure_cycle_path(@cycle, tab: "perguntas"), alert: @question.errors.full_messages.first
    end
  end

  def destroy
    Question.find(params[:id]).destroy
    redirect_to configure_cycle_path(@cycle, tab: "perguntas"), notice: "Pergunta removida."
  end

  def reorder
    question  = Question.find(params[:id])
    cycle     = question.cycle
    direction = params[:direction]
    questions = cycle.questions.order(:position).to_a
    idx       = questions.index(question)

    if direction == "up" && idx > 0
      questions[idx], questions[idx - 1] = questions[idx - 1], questions[idx]
    elsif direction == "down" && idx < questions.length - 1
      questions[idx], questions[idx + 1] = questions[idx + 1], questions[idx]
    end

    questions.each_with_index { |q, i| q.update_column(:position, i) }
    redirect_to configure_cycle_path(cycle, tab: "perguntas")
  end

  private

  def set_cycle
    @cycle = Cycle.find(params[:cycle_id])
  end

  def question_params
    params.require(:question).permit(:text, :dimension, :answer_type, :min_score, :max_score, :weight, :evaluator_types)
  end
end
