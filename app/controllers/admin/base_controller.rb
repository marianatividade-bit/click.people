module Admin
  class BaseController < ApplicationController
    before_action :require_admin!

    private

    def require_admin!
      unless current_person.hr_admin? || current_person.business_partner?
        redirect_to root_path, alert: "Acesso restrito à área administrativa."
      end
    end
  end
end
