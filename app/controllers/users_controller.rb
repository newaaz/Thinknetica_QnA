class UsersController < ApplicationController
  before_action :authenticate_user!

  def awards    
    @user = User.find(params[:id])
    @awards = @user.awards
  end
end


