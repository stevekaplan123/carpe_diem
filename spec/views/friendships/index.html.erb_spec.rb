require 'rails_helper'

RSpec.describe "friendships/index", type: :view do
  before(:each) do
    assign(:friendships, [
      Friendship.create!(
        :user_id => 1,
        :user_name => "User Name",
        :friend_id => 2,
        :friend_name => "Friend Name"
      ),
      Friendship.create!(
        :user_id => 1,
        :user_name => "User Name",
        :friend_id => 2,
        :friend_name => "Friend Name"
      )
    ])
  end

  it "renders a list of friendships" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "User Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Friend Name".to_s, :count => 2
  end
end
