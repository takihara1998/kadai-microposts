class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.like(micropost)
    flash[:success] = '投稿にいいねしました。'
    redirect_back(fallback_location: root_path)  
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(micropost)
    flash[:success] = '投稿へのいいねを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  # private
  
  #   def set_post
  #       @micropost = Micropost.find(params[:micropost_id])
  #   end

end
