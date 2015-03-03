require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:one)
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, account: { name: Faker::Internet.user_name,
        password: 'secret', password_confirmation: 'secret' }
    end
    assert_redirected_to accounts_path
  end

  test "should update account" do
    patch :update, id: @account, account: { name: @account.name,
      password: 'secret', password_confirmation: 'secret' }
    assert_redirected_to accounts_path
  end
end
