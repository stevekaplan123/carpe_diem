class Filter

  attr_reader :events	

  def initialize(user_id, location, near_me, friends, time)
    @events = Event.all

    if time != '0'
      if time == '30'
        @events = @events.where(time_occurrence: (Time.now-4.hours)..(Time.now-4.hours+time.to_i.minutes))
      else
        @events = @events.where(time_occurrence: (Time.now-4.hours)..(Time.now-4.hours+time.to_i.hours))
      end
      if (@events.first.nil?)
         puts "time - events is nil"
       else
         puts @events.first.name
      end
   end

   if friends != '0'
      @events = filterByFriends(@events, user_id, friends)
      if (@events.first.nil?)
       puts "friend - events is nil"
      else
       puts @events.first.name
     end
   end

   if near_me != '0'
      lat, lng = location.split(",")
      @events = filterByLocation(@events, lat, lng, near_me)

      puts "location filtered"
      puts @events.length
      if (@events.first.nil?)
       puts "loc - events is nil"
     else
       puts @events.first.name
      end
    end

    puts "end of filter"
    puts @events
    puts @events.length
    if (@events.first.nil?)
      puts "end - events is nil"
    else
      puts @events.first.name
    end
    puts "-----"
end

def filterByFriends(events, user_id, friends)
  friend_events = []
  my_friends = []

  @users_friendships = Friendship.where(user_id: user_id)
  @users_friendships.each do |friendship|
    temp_friend = User.find_by(id: friendship["friend_id"])
    if temp_friend != nil
      my_friends.push(temp_friend)
    end
  end 

  if friends=='going_to'
    my_friends.each do |friend|
      friend_attendances = Attendance.where(user_id: friend["id"])
      friend_attendances.each do |fa|
        temp_event = events.find_by(id: fa["event_id"])
        if temp_event != nil
         friend_events.push(temp_event)
       end
     end
   end
 elsif friends=='created'
  my_friends.each do |friend|
    puts "friend ="+friend["id"].to_s
    friend_creations = events.where(creator_id: friend["id"])
    friend_creations.each do |fc|
      friend_events.push(fc)
    end
  end   
end
friend_events
end 


def convertLatLngToMeters(orig_coords, end_coords)
  lat1 = orig_coords[0]
  lat2 = end_coords[0]
  lon1 = orig_coords[1]
  lon2 = end_coords[1]
  dLat = (lat2 - lat1) * 3.1415 / 180
  dLon = (lon2 - lon1) * 3.1415 / 180
  a = Math.sin(dLat/2) * Math.sin(dLat/2) +
  Math.cos(lat1 * 3.1415 / 180) * Math.cos(lat2 * 3.1415 / 180) *
  Math.sin(dLon/2) * Math.sin(dLon/2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
  d = 6378.137 * c * 1000
  d
end

def filterByLocation(events, lat, lng, how_far)
      #  0.008 is distance from North to Theater
      #  0.002 is distance from North to Usdan
      #  0.0036 is distance from Gosman Gym to Usdan
      #  a reasonable distance to use to discern whether I am "close" to an event
      #  is a distance of 0.0045

      my_coords = [lat.to_f, lng.to_f]
      filtered_events = []
      events.each do |event|
        event_coords = [event.latitude.to_f, event.longitude.to_f]
        dist = convertLatLngToMeters(my_coords, event_coords)
        puts "dist is: #{}", dist
        if dist <= how_far.to_f
          filtered_events.push(event)
        end
      end
      filtered_events
    end


  end
