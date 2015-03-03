class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.find_by(name: params[:name])
    if account and account.authenticate(params[:password])
      session[:account_id] = account.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid user/password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: "Logged out"
  end
end
