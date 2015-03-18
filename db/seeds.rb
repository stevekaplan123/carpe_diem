# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create an admin
User.create(name: 'admin', email: 'random@brandeis.edu',
            num_events: 0, admin: true,
            password: '123456',
            password_confirmation: '123456')

# Create 100 random users
100.times do
  pw = Faker::Internet.password(8)
  user = Faker::Internet.user_name

  Fabricate(:user,
            name: user,
            email: user + Faker::Number.number(3) + "@brandeis.edu",
            password: pw, password_confirmation: pw)
end


#make tags
Tag.create(name: 'academic')
Tag.create(name: 'competition')
Tag.create(name: 'entertainment')
Tag.create(name: 'food')
Tag.create(name: 'game')
Tag.create(name: 'off-campus')
Tag.create(name: 'music')
Tag.create(name: 'party')
Tag.create(name: 'sports')





# 100.times { Fabricate(:attendance) }
# 100.times { Fabricate(:event) }
