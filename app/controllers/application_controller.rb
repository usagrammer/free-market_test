class ApplicationController < ActionController::Base
  before_action :configure_permitted_paramaters, if: :devise_controller? ## 追加

  private

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def configure_permitted_paramaters ## 追加
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :first_name, :first_name_reading, :last_name, :last_name_reading, :birthday])
  end

end
