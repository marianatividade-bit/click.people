class FeedbacksController < ApplicationController
  def index
    @given    = Feedback.where(giver: current_person).order(created_at: :desc)
    @received = Feedback.where(receiver: current_person).order(created_at: :desc)
  end

  def show
    @feedback = Feedback.find(params[:id])
    unless @feedback.giver == current_person || @feedback.receiver == current_person ||
           current_person.hr_admin? || current_person.business_partner?
      redirect_to feedbacks_path, alert: "Sem permissão."
    end
  end

  def new
    @feedback = Feedback.new
    @people   = Person.active.where.not(id: current_person.id).order(:name)
    @cycles   = Cycle.order(created_at: :desc)
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.giver = current_person

    if @feedback.save
      redirect_to feedbacks_path, notice: "Feedback enviado!"
    else
      @people = Person.active.where.not(id: current_person.id).order(:name)
      @cycles = Cycle.order(created_at: :desc)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:receiver_id, :cycle_id, :message, :visibility)
  end
end
