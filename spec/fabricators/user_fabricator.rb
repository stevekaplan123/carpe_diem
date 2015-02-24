Fabricator(:user) do
  user_name { Faker::Internet.user_name }
  email { Faker::Internet.email }
  num_events { Faker::Number.number(3) }
  geo_info { Faker::Address.latitude }
end
