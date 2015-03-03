json.array!(@events) do |event|
  json.extract! event, :id, :creator_id, :name, :time_creation, :time_occurrence, :location, :longitude, :latitude, :description
  json.url event_url(event, format: :json)
end
