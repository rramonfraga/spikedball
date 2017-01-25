class CommunitiesController < ApplicationController
  before_action :authenticate_user!

  def show
    if @community = Community.find_by(id: params[:code])
      @championships = @community.championships
    else
      render status: 404, file: '/public/404.html'
    end
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new community_params
    if @community.save
      current_user.communities << @community
      WelcomeCommunityMailer.welcome_community(current_user, @community).deliver_now
      redirect_to action: 'index', controller: 'welcome', community_code: @community.code
    else
      render(:new)
    end
  end

  def assign
    @community = Community.find_by(id: params[:code])
    @user = User.find_by(id: params[:user_id])
    if @community = Community.find_by(id: params[:code])
      @community.users << @user
    else
      render status: 404, file: '/public/404.html'
    end
  end

  private
  def community_params
    params.require(:community).permit(:name)
  end
end
