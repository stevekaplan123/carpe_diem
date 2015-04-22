class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User"

  # Returns true if p1 and p2 are friends
  def self.friends?(p1, p2)
    not self.where('user_id = ?', p1.id).where('friend_id = ?', p2.id).empty?
  end

end