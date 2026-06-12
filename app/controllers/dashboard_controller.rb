class DashboardController < ApplicationController
  def index
    @active_cycle = Cycle.where(status: [:nominations_open, :validating, :evaluation_open, :calibration]).order(updated_at: :desc).first
    @my_pending_evaluations = @active_cycle ? Evaluation.where(evaluator: current_person, cycle: @active_cycle, status: [:draft, :in_progress]).count : 0
    @total_people = Person.active.count
    @total_cycles = Cycle.count
    @recent_cycles = Cycle.order(created_at: :desc).limit(5)
    @my_nominations_count = @active_cycle ? @active_cycle.nominations.where(evaluated: current_person).count : 0
    @is_participant = @active_cycle ? @active_cycle.cycle_participants.exists?(person: current_person) : false
  end
end
