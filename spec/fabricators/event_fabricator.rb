Fabricator(:event) do
  creator_id { Faker::Number.number(2) }
  name { Faker::Lorem.words }
  time_occurrence { Faker::Time.forward(1, :morning) }
  location { Faker::Address.street_address }
  longitude { Faker::Address.longitude }
  latitude { Faker::Address.latitude }
  description { Faker::Lorem.sentence(5) }
end
