class AdminController < ApplicationController
  def index
    @total_accounts = Account.count
  end
end
