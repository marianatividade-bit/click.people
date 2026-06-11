module People
  class SessionsController < ApplicationController
    skip_before_action :authenticate_person!

    def new
    end

    def destroy
      sign_out current_person
      redirect_to new_person_session_path, notice: "Você saiu com sucesso."
    end
  end
end
