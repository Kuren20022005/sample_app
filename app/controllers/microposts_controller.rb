class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    attach_image
    return redirect_after_create if @micropost.save

    render_create_failure
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

  def attach_image
    @micropost.image.attach params.dig(:micropost, :image)
  end

  def redirect_after_create
    flash[:success] = t("microposts.create.success")
    redirect_to root_url
  end

  def render_create_failure
    @pagy, @feed_items = pagy(current_user.feed,
                              items: Settings.micropost.content.maximum)
    render "static_pages/home", status: :unprocessable_entity
  end
end
