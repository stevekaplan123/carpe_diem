Fabricator(:event) do
  creator_id { Faker::Number.number(2) }
  event_name { Faker::Lorem.words }
  time_creation { Faker::Time.forward(1, :morning) }
  time_occurrence { Faker::Time.forward(23, :evening) }
  location { Faker::Address.street_address }
  longitude { Faker::Address.longitude }
  latitude { Faker::Address.latitude }
  description { Faker::Lorem.sentence }
end
