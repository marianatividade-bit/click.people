class PdisController < ApplicationController
  before_action :set_pdi, only: [:show, :edit, :update]

  def index
    if current_person.hr_admin? || current_person.business_partner?
      @pdis = Pdi.includes(:person).order(created_at: :desc)
      @owner = nil
    else
      @pdis = Pdi.where(person: current_person).order(created_at: :desc)
      @owner = current_person
    end
  end

  def show; end

  def new
    @pdi = Pdi.new
    @cycles = Cycle.order(created_at: :desc)
  end

  def create
    @pdi = Pdi.new(pdi_params)
    @pdi.person = current_person
    @pdi.actions ||= []

    if @pdi.save
      redirect_to pdis_path, notice: "PDI criado com sucesso."
    else
      @cycles = Cycle.order(created_at: :desc)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_pdi!
    @cycles = Cycle.order(created_at: :desc)
  end

  def update
    authorize_pdi!
    if @pdi.update(pdi_params)
      redirect_to @pdi, notice: "PDI atualizado."
    else
      @cycles = Cycle.order(created_at: :desc)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_pdi
    @pdi = Pdi.find(params[:id])
  end

  def authorize_pdi!
    unless @pdi.person == current_person || current_person.hr_admin? || current_person.business_partner?
      redirect_to pdis_path, alert: "Sem permissão."
    end
  end

  def pdi_params
    params.require(:pdi).permit(:title, :description, :status, :due_date, :cycle_id)
  end
end
