module People
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      person = Person.from_omniauth(request.env["omniauth.auth"])

      if person.persisted?
        sign_in_and_redirect person, event: :authentication
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
        redirect_to root_url, alert: person.errors.full_messages.join("\n")
      end
    end

    def failure
      redirect_to root_url, alert: "Autenticação falhou. Tente novamente."
    end
  end
end
