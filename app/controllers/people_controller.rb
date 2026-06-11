class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update]
  before_action :require_admin!, only: [:edit, :update]

  def index
    @people = Person.order(:name)
  end

  def show; end

  def edit; end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: "Pessoa atualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def require_admin!
    unless current_person.hr_admin? || current_person.business_partner?
      redirect_to @person, alert: "Sem permissão."
    end
  end

  def person_params
    params.require(:person).permit(:role, :status, :chapter_manager_id, :stream_manager_id)
  end
end
