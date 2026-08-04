class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t("microposts.create.success")
      return redirect_to root_url
    end

    @pagy, @feed_items = pagy(current_user.feed,
                              items: Settings.micropost.content.maximum)
    render "static_pages/home", status: :unprocessable_entity
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("microposts.destroy.success")
    else
      flash[:danger] = t("microposts.destroy.failure")
    end
    redirect_to request.referer || root_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:danger] = t("microposts.destroy.invalid")
    redirect_to request.referer || root_url
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end
end
