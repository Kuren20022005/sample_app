class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.ordered, items: Settings.per_page
  end

  def show
    @relationship = current_user.active_relationships.find_by(
      followed_id: @user.id
    )
    @page, @microposts = pagy @user.microposts, items: Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t("users.new.info")
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("users.edit.success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("users.destroy.success")
    else
      flash[:danger] = t("users.destroy.failure")
    end
    redirect_to users_path
  end

  def following
    @title = t("users.relation.following.title")
    @pagy, @users = pagy @user.following, items: Settings.user.follow.show.size
    render :show_follow
  end

  def followers
    @title = t("users.relation.followers.title")
    @pagy, @users = pagy @user.followers, items: Settings.user.follow.show.size
    render :show_follow
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("users.edit.warning")
    redirect_to root_path
  end

  # Confirms the correct user.
  def correct_user
    return if current_user? @user

    flash[:error] = t("users.edit.correct_user")
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
