require 'rails_helper'

RSpec.describe "friendships/show", type: :view do
  before(:each) do
    @friendship = assign(:friendship, Friendship.create!(
      :user_id => 1,
      :user_name => "User Name",
      :friend_id => 2,
      :friend_name => "Friend Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/User Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Friend Name/)
  end
end
