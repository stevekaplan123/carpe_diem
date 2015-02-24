Fabricator(:attendance) do
  event_id { Faker::Number.number(2) }
  user_id { Faker::Number.number(2) }
end
