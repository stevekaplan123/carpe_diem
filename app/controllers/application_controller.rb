class ApplicationController < ActionController::Base
  # check session on every page. will have to rewrite the tests
  # before_action :authorize
  protect_from_forgery with: :exception
  include SessionsHelper

  protected
    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end
end
