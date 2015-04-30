json.array!(@events) do |event|
  json.extract! event, "id", "creator_id", "name", "time_occurrence", "longitude", "latitude", "description", "attendees"
  json.url event_url(event, format: :json)
end
