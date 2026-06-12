module Admin
  class PeopleController < BaseController
    def index
      @people = Person.order(:name)
    end

    def new
      @person = Person.new
    end

    def create
      @person = Person.new(person_params)
      @person.status = :active
      if @person.save
        redirect_to admin_people_path, notice: "Colaborador criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @person = Person.find(params[:id])
    end

    def update
      @person = Person.find(params[:id])
      if @person.update(person_params)
        redirect_to admin_people_path, notice: "Colaborador atualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @person = Person.find(params[:id])
      if @person.id == current_person.id
        redirect_to admin_people_path, alert: "Você não pode excluir sua própria conta."
      else
        @person.destroy
        redirect_to admin_people_path, notice: "Colaborador excluído."
      end
    end

    def deactivate
      @person = Person.find(params[:id])
      if @person.id == current_person.id
        redirect_to admin_people_path, alert: "Você não pode desativar sua própria conta."
      else
        @person.update!(status: :inactive)
        redirect_to admin_people_path, notice: "#{@person.name} foi desativado."
      end
    end

    def reactivate
      @person = Person.find(params[:id])
      @person.update!(status: :active)
      redirect_to admin_people_path, notice: "#{@person.name} foi reativado."
    end

    private

    def person_params
      params.require(:person).permit(:name, :email, :role, :chapter_manager_id, :stream_manager_id, :photo)
    end
  end
end
