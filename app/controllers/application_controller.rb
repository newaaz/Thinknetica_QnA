class ApplicationController < ActionController::Base
  before_action :set_gon_current_user 

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  #check_authorization
  #skip_authorization

  private 

  def set_gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
