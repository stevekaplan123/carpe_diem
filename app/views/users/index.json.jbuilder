json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :num_events, :geo_info
  json.url user_url(user, format: :json)
end
