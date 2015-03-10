class StaticPagesController < ApplicationController
  skip_before_action :authorize

  def home
    if logged_in?
      redirect_to events_path
    end
  end

  def help
  end

  def about
  end
end
