require 'rails_helper'

RSpec.describe "friendships/new", type: :view do
  before(:each) do
    assign(:friendship, Friendship.new(
      :user_id => 1,
      :user_name => "MyString",
      :friend_id => 1,
      :friend_name => "MyString"
    ))
  end

  it "renders new friendship form" do
    render

    assert_select "form[action=?][method=?]", friendships_path, "post" do

      assert_select "input#friendship_user_id[name=?]", "friendship[user_id]"

      assert_select "input#friendship_user_name[name=?]", "friendship[user_name]"

      assert_select "input#friendship_friend_id[name=?]", "friendship[friend_id]"

      assert_select "input#friendship_friend_name[name=?]", "friendship[friend_name]"
    end
  end
end
