class DashboardController < ApplicationController
  def index
    @person = current_person

    case @person.role
    when "hr_admin", "business_partner"
      @cycles          = Cycle.order(created_at: :desc).limit(5)
      @open_cycle      = Cycle.find_by(status: :open)
      @people_count    = Person.active.count
      @pending_evals   = Evaluation.where(status: :draft).count
    when "director"
      @open_cycle      = Cycle.find_by(status: :open)
      @team            = Person.where(stream_manager_id: @person.id).or(Person.where(chapter_manager_id: @person.id))
      @team_eval_count = @open_cycle ? Evaluation.where(cycle: @open_cycle, evaluated: @team).count : 0
    when "manager"
      @open_cycle      = Cycle.find_by(status: :open)
      @direct_reports  = Person.where(chapter_manager_id: @person.id).or(Person.where(stream_manager_id: @person.id))
      @my_evals        = @open_cycle ? Evaluation.for_evaluator(@person).where(cycle: @open_cycle) : Evaluation.none
    else
      @open_cycle      = Cycle.find_by(status: :open)
      @my_evals        = @open_cycle ? Evaluation.for_evaluator(@person).where(cycle: @open_cycle) : Evaluation.none
      @my_pdis         = Pdi.where(person: @person).where.not(status: :cancelled).order(created_at: :desc).limit(3)
      @recent_feedback = Feedback.where(receiver: @person).order(created_at: :desc).limit(5)
    end
  end
end
