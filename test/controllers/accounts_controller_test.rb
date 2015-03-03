require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
 test "should create account" do
  assert_difference('Account.count') do
    post :create, account: { name: 'sam', password: 'secret',
      password_confirmation: 'secret' }
  end

  assert_redirected_to accounts_path
end

  test "should update account" do
    patch :update, id: @account, account: { name: @account.name,
      password: 'secret', password_confirmation: 'secret' }
    assert_redirected_to accounts_path
  end
end
