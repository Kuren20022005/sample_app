class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  private

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("users.edit.logged_in")
    redirect_to login_url
  end
end
