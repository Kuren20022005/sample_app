class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow(@user)
    @relationship = current_user.active_relationships.find_by(
      followed_id: @user.id
    )
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
  end

  def destroy
    @user = @relationship.followed
    @relationship.destroy

    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
  end

  private

  def load_user
    @user = User.find_by(id: params[:followed_id])
    return if @user

    flash[:danger] = t("users.show.warrning")
    redirect_to root_url
  end

  def load_relationship
    @relationship = Relationship.find_by(id: params[:id])
    return if @relationship

    flash[:danger] = t("users.relation.not_found")
    redirect_to root_url
  end
end
