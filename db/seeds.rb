# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create an admin
# User.create(name: 'admin', email: 'random@brandeis.edu',
#             num_events: 0, admin: true,
#             password: '123456',
#             password_confirmation: '123456')

# Create 4 users
User.create(name: 'Vladimir', email: 'vsusaya@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

User.create(name: 'Viet', email: 'lttviet@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

User.create(name: 'Ralph', email: 'lfzhou@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

User.create(name: 'Steve', email: 'skaplan@brandeis.edu',
            num_events: 0, admin: false,
            password: '12345',
            password_confirmation: '12345')

other_users = ["James", "Bruce Wayne", "Gandolf", "Hulk", "Darth Vader", 
			   "Ned Stark", "Tyrion", "Aragorn", "Golumn", "Frodo"]

other_users.each do |user|
	User.create(name: user, email: "test_#{user}@brandeis.edu",
            	num_events: 0, admin: false,
            	password: '12345',
            	password_confirmation: '12345')
end

# Create 10 random users
# 10.times do
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
	pool.push("We got food and drink and any kind of food that you could possibly think of. If you don't come, it's your loss. It's at Gzang 124.")
	pool.push("If you don't come to this you'll fail your next exam. We are super duper serious. Study in library.")
	pool.push("What are the odds you come and play odds with us? Just outside the doorway.")
	pool.push("I want to head to IKEA this afternoon and searching for companion. Anyone wanna go? No worries I have the car. I can pick you up near campus.")
	pool.push("I want to play dragon age inquisition. Anyone with me???")
	pool.push("A fun game held by the dark knight... could be batman or Darth Vader!")
	pool.push("TLOR movie trilogy marathon. Yes it's collection's edition. And yes we have popcorn and drink, and pillows just in case.")
	pool.push("You'd never know what's on unless you come.")
	pool.push("Yeah! It's my last day at school! How about some fun feast! Bring ideas!")
	pool.push("We are gonna meet outside the buiding and head to Boston for some Japanese food. Anyone with us?")
	return pool[rand(0...pool.size)]
end

def random_name
	pool = Array.new
	pool.push("Feast or party?")
	pool.push("Study in library")
	pool.push("Let's play a game...")
	pool.push("I can't believe we are having...")
	pool.push("Come and have fun")
	pool.push("Study for the final")
	pool.push("Ice bucket contest")
	pool.push("Crazy ride")
	pool.push("The force is rising")
	pool.push("Truth or dare")
	return pool[rand(0...pool.size)]
end

# make time for the SCD demo
def make_time
	day = rand(6..7)
	if day == 6
		return DateTime.new(2015, 05, day, rand(15..23), [0,5,10,15,20,25,30,35,40,45,50,55].sample, 0)
	else
		return DateTime.new(2015, 05, day, rand(0..9), [0,5,10,15,20,25,30,35,40,45,50,55].sample, 0)
	end
end

# make events for demo
# viet's event
Event.create(name: random_name,
			 creator_id: 2,
			 time_occurrence: DateTime.new(2015, 05, 06, 19, 30, 0),
			 longitude: rand(-71.265700...-71.252991),
			 latitude: rand(42.360563...42.371222),
			 description: random_description,
			 tags: random_tags)

Event.create(name: random_name,
			 creator_id: 2,
			 time_occurrence: DateTime.new(2015, 05, 07, 00, 30, 0),
			 longitude: rand(-71.265700...-71.252991),
			 latitude: rand(42.360563...42.371222),
			 description: random_description,
			 tags: random_tags)

50.times do
	Event.create(name: random_name,
				 creator_id: rand(3..User.all.count),
				 time_occurrence: make_time,
				 longitude: rand(-71.265700...-71.252991),
				 latitude: rand(42.360563...42.371222),
				 description: random_description,
				 tags: random_tags)
end

#make attendances
Event.all.each do |event|
	Attendance.create(event_id: event.id, user_id: event.creator_id)
	rand(1..User.all.count).times do
		r = rand(1..User.all.count)
		if !event.users.exists?(r) && r != event.creator_id
			Attendance.create(event_id: event.id,
							  user_id: r)
		end
	end
end

# 100.times { Fabricate(:attendance) }
# 100.times { Fabricate(:event) }
