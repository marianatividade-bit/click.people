module Admin
  class CargosController < BaseController
    before_action :set_cargo, only: [:show, :edit, :update, :destroy]

    def index
      @cargos = Cargo.ordered
    end

    def show; end

    def new
      @cargo = Cargo.new
    end

    def create
      @cargo = Cargo.new(cargo_params)
      if @cargo.save
        redirect_to admin_cargos_path, notice: "Cargo criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @cargo.update(cargo_params)
        redirect_to admin_cargos_path, notice: "Cargo atualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @cargo.update!(active: false)
      redirect_to admin_cargos_path, notice: "Cargo desativado."
    end

    private

    def set_cargo
      @cargo = Cargo.find(params[:id])
    end

    def cargo_params
      params.require(:cargo).permit(:name, :level, :description, :active)
    end
  end
end
