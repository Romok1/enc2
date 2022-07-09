class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  def confirmation
    authenticate_user!(force: true)
  end

  protected

  def after_sign_up_path_for(_resource)
    registration_confirmation_path
  end
end
