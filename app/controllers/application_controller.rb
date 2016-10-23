class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, :if => :devise_controller?

  helper_method :current_community

  protected
  def authenticate_admin!
    unless current_user.admin?(current_community)
      redirect_to '/'
    end
  end

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def current_community
    @_current_community ||= begin
      Community.find_by(id: params[:community_code]) ||
        Community.find_by(id: params[:code]) ||
        current_user.communities.first ||
        Community.find_by(name: 'Communities')
    end
  end
end
