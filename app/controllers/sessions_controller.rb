class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user
    if authenticated_user?(user)
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def find_user
    User.find_by email: params.dig(:session, :email)&.downcase
  end

  def authenticated_user? user
    user&.authenticate params.dig(:session, :password)
  end

  def handle_successful_login user
    if user.activated?
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || user
    else
      flash[:warning] = t("account_activations.not_activated")
      redirect_to root_url, status: :see_other
    end
  end

  def handle_failed_login
    flash.now[:danger] = t("session.create.failure")
    render :new, status: :unprocessable_entity
  end
end
