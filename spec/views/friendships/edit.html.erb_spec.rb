require 'rails_helper'

RSpec.describe "friendships/edit", type: :view do
  before(:each) do
    @friendship = assign(:friendship, Friendship.create!(
      :user_id => 1,
      :user_name => "MyString",
      :friend_id => 1,
      :friend_name => "MyString"
    ))
  end

  it "renders the edit friendship form" do
    render

    assert_select "form[action=?][method=?]", friendship_path(@friendship), "post" do

      assert_select "input#friendship_user_id[name=?]", "friendship[user_id]"

      assert_select "input#friendship_user_name[name=?]", "friendship[user_name]"

      assert_select "input#friendship_friend_id[name=?]", "friendship[friend_id]"

      assert_select "input#friendship_friend_name[name=?]", "friendship[friend_name]"
    end
  end
end
