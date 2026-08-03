class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.create.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.create.danger"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if user_params[:password].empty? ||
       user_params[:password_confirmation].empty?
      @user.errors.add :password, t("password_resets.update.empty")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t("password_resets.update.success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "password_resets.load_user.danger"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "password_resets.valid_user.danger"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_resets.check_expiration.danger"
    redirect_to new_password_reset_url
  end
end
