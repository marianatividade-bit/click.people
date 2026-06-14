class Onboarding::FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update]

  def index
    if current_person.hr_admin? || current_person.business_partner?
      @feedbacks = ExperienceFeedback.includes(:person, :leader).order(created_at: :desc)
    else
      @feedbacks = ExperienceFeedback.where(person: current_person)
                                     .or(ExperienceFeedback.where(leader: current_person))
                                     .includes(:person, :leader)
    end
  end

  def show; end

  def new
    @feedback = ExperienceFeedback.new
    @people   = Person.active.order(:name)
  end

  def create
    @feedback = ExperienceFeedback.new(feedback_params)
    @feedback.leader = current_person
    if @feedback.save
      redirect_to onboarding_feedback_path(@feedback), notice: "Feedback de experiência criado."
    else
      @people = Person.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless can_edit?
      redirect_to onboarding_feedbacks_path, alert: "Acesso restrito."
    end
  end

  def update
    if @feedback.update(feedback_params)
      if params[:mark_complete]
        @feedback.update(status: :completed, completed_at: Time.current)
      end
      redirect_to onboarding_feedback_path(@feedback), notice: "Feedback atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_feedback
    @feedback = ExperienceFeedback.find(params[:id])
  end

  def can_edit?
    @feedback.leader == current_person ||
      current_person.hr_admin? || current_person.business_partner?
  end

  def feedback_params
    params.require(:experience_feedback).permit(
      :person_id, :public_notes, :private_notes,
      :meeting_at, :calendar_event_id, :status
    )
  end
end
