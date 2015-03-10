class ApplicationController < ActionController::Base
  # check session on every page. will have to rewrite the tests
  before_action :authorize
  protect_from_forgery with: :exception
  include SessionsHelper

  protected
    def authorize
      unless logged_in?
        redirect_to login_url
      end
    end
end
