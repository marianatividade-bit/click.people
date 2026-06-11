module Admin
  class DashboardController < BaseController
    def index
      @people_count    = Person.active.count
      @inactive_count  = Person.inactive.count
      @cargos_count    = Cargo.active.count
      @open_cycle      = Cycle.find_by(status: :open)
      @pending_evals   = Evaluation.where(status: :draft).count
      @active_plans    = RecoveryPlan.where(status: :active).count
    end
  end
end
