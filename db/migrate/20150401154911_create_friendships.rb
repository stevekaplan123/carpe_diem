class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.string :user_name
      t.integer :friend_id
      t.string :friend_name

      t.timestamps null: false
    end
  end
end
