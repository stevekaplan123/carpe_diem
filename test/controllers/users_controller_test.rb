require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    
  @update = {
      
          user_name: 'Some User',
          email: 'lfzhou@brandeis.edu',
          num_events: 1,
          geo_info: '111'
      
      }
  end



  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      # post :create, user: { email: @user.email, geo_info: @user.geo_info, num_events: @user.num_events, user_name: @user.user_name }
      post :create, user: @update
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: @update
    # patch :update, id: @user, user: { email: @user.email, geo_info: @user.geo_info, num_events: @user.num_events, user_name: @user.user_name }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
