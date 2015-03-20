class ApplicationController < ActionController::Base
  # check session on every page. will have to rewrite the tests
  before_action :authorize
  protect_from_forgery with: :exception
  include SessionsHelper

  protected
    def authorize
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_path
      end
    end
end
