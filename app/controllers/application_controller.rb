class ApplicationController < ActionController::Base
  before_action :authenticate_person!, unless: :devise_controller?

  allow_browser versions: :modern
  stale_when_importmap_changes

  private

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    "/login"
  end
end
