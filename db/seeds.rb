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

# Create 4 users
User.create(name: 'Ralph', email: 'lfzhou@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

User.create(name: 'Vladimir', email: 'vsusaya@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

User.create(name: 'Viet', email: 'lttviet@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

User.create(name: 'Steve', email: 'skaplan@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

# Create 100 random users
# 100.times do
#   pw = Faker::Internet.password(8)
#   user = Faker::Internet.user_name

#   Fabricate(:user,
#             name: user,
#             email: user + Faker::Number.number(3) + "@brandeis.edu",
#             password: pw, password_confirmation: pw)
# end


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

#make random events
def random_tags
	first = rand(1..3)
	second = rand(4..6)
	third = rand(7..9)
	return first.to_s + "," + second.to_s + "," + third.to_s
end

def random_description
	pool = Array.new
	pool.push("We got food!")
	pool.push("If you don't come you'll fail your next exam. We are serious.")
	pool.push("Must have 15 words Must have 15 words Must have 15 words Must have 15 words Must have 15 words Must have 15 words ")
	pool.push("I have no idea what's going on here")
	pool.push("I want to play dragon age inquisition. Anyone with me???")
	pool.push("A baskedball game held by Darth Vader")
	pool.push("TLOR movie trilogy marathon. Yes we have popcorn and drink.")
	pool.push("Party and more.")
	pool.push("What trick is this?")
	pool.push("Hahahahaha")
	return pool[rand(0...pool.size)]
end

def random_name
	pool = Array.new
	pool.push("Feast or party?")
	pool.push("An interesting event...")
	pool.push("Let's play a game...")
	pool.push("I can't believe we are having...")
	pool.push("Come and have fun")
	pool.push("Study for the final")
	pool.push("Ice bucket contest")
	pool.push("A fun party")
	pool.push("The force is rising")
	pool.push("Truth or dare")
	return pool[rand(0...pool.size)]
end

50.times do
	Event.create(name: random_name,
				 creator_id: rand(4)+2,
				 time_occurrence: rand(1.days).seconds.from_now,
				 longitude: rand(-71.265700...-71.252991),
				 latitude: rand(42.360563...42.371222),
				 description: random_description,
				 tags: random_tags)
end

#make attendances
Event.all.each do |event|
	rand(1..5).times do
		r = rand(1..5)
		if !event.users.exists?(r)
			Attendance.create(event_id: event.id,
							  user_id: r)
		end
	end
end

# 100.times { Fabricate(:attendance) }
# 100.times { Fabricate(:event) }
