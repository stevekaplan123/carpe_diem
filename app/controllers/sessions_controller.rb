class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      log_in user
      redirect_to user
    else
      redirect_to login_path, alert: "Invalid user/password"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
