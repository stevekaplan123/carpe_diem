json.array!(@friendships) do |friendship|
  json.extract! friendship, :id, :user_id, :user_name, :friend_id, :friend_name
  json.url friendship_url(friendship, format: :json)
end
