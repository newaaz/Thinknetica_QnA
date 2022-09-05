class ApplicationController < ActionController::Base
  before_action :set_gon_current_user 

  private 

  def set_gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
