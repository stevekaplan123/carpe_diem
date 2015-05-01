require 'byebug'
class Filter

attr_reader :events	

def initialize(user_id, location, near_me, other, time, tag)
  @events = Event.all
  if time != '0'
    if time == '30'
      @events = @events.where(time_occurrence: (Time.now-4.hours)..(Time.now-4.hours+time.to_i.minutes))
    else
      @events = @events.where(time_occurrence: (Time.now-4.hours)..(Time.now-4.hours+time.to_i.hours))
    end
  end
  if tag != '0'
    @events = filterByTags(@events, tag)
  end
  if other != '0'
    @events = filterByOther(@events, user_id, other)
  end
  if near_me != '0'
    lat, lng = location.split(",")
    @events = filterByLocation(@events, lat, lng, near_me)
  end
  @events = Filter.addAttendancestoEvents(@events)
end

def filterByTags(events, tag)
  filtered_events = []
  events.each do |event|
    if event["tags"].include? tag
        filtered_events.push(event)
    end
  end
  filtered_events
end

def self.convertNumberIntoTag(numbers)
  numbers.gsub! "1", "academic"
  numbers.gsub! "2", "competition"
  numbers.gsub! "3", "entertainment"
  numbers.gsub! "4", "food"
  numbers.gsub! "5", "game"
  numbers.gsub! "6", "off-campus"
  numbers.gsub! "7", "music"
  numbers.gsub! "8", "party"
  numbers.gsub! "9", "sports"
  numbers
end

def self.search(searchValue)
  #@events = Event.all;  for each event, check each of the three in turn and add it to 
  #actual_events array to return
  #select distinct * from events where 
      @events = []
      all_events = Event.all
      all_events.each do |event|
          if event["description"].include? searchValue
              @events.push(event)
          elsif event["name"].include? searchValue
              @events.push(event)
          else
              tags = Filter.convertNumberIntoTag(event["tags"])
              if tags.include? searchValue
                @events.push(event)
              end
          end
      end
      @events = Filter.addAttendancestoEvents(@events)
end

def filterByOther(events, user_id, other)
  friend_events = []
  my_friends = []

  @users_friendships = Friendship.where(user_id: user_id)
  @users_friendships.each do |friendship|
    temp_friend = User.find_by(id: friendship["friend_id"])
    if temp_friend != nil
      my_friends.push(temp_friend)
    end
  end 

  if other=='going_to'
    my_friends.each do |friend|
      friend_attendances = Attendance.where(user_id: friend["id"])
      friend_attendances.each do |fa|
        temp_event = events.find_by(id: fa["event_id"])
        if temp_event != nil
         friend_events.push(temp_event)
       end
     end
   end
 elsif other=='created'
  my_friends.each do |friend|
    puts "friend ="+friend["id"].to_s
    friend_creations = events.where(creator_id: friend["id"])
    friend_creations.each do |fc|
      friend_events.push(fc)
    end
  end 
  elsif other=="i_created"
    @created_events = events.where(creator_id: user_id)
    @created_events.each do |ce|
      friend_events.push(ce)
    end
  elsif other=="im_going" 
    my_attendances = [] 
    events.each do |event|
       temp_attendances = event.attendances.where(user_id: user_id)
       temp_attendances.each do |temp_att|
          friend_events.push(events.find_by(id: temp_att["event_id"]))
       end
    end
  end
  friend_events
end 
                  
def self.addAttendancestoEvents(events)
  modifiedEvents = Array.new(events.length)
  count=0
  events.each do |event|
    modifiedEvents[count] = Hash.new
    modifiedEvents[count]["latitude"] = event["latitude"]
    modifiedEvents[count]["longitude"] = event["longitude"]
    modifiedEvents[count]["description"] = event["description"]
    modifiedEvents[count]["creator_id"] = event["creator_id"]
    modifiedEvents[count]["id"] = event["id"]
    modifiedEvents[count]["name"] = event["name"]
    modifiedEvents[count]["time_occurrence"] = event["time_occurrence"]
    event_attendees = event.users
    attendees_names_joined = ""
    event_attendees.each do |event_attendee|
      attendees_names_joined = attendees_names_joined + event_attendee["id"].to_s + ":" + event_attendee["name"] + ", "
    end
    attendees_names_joined = attendees_names_joined.chop #remove the ", " so chop twice
    attendees_names_joined = attendees_names_joined.chop
    modifiedEvents[count]["attendees"] =  attendees_names_joined
    count += 1
  end
  modifiedEvents
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

      my_coords = [lat.to_f, lng.to_f]
      filtered_events = []
      events.each do |event|
        event_coords = [event["latitude"].to_f, event["longitude"].to_f]
        dist = convertLatLngToMeters(my_coords, event_coords)
        if dist <= how_far.to_f
          filtered_events.push(event)
        end
      end
      filtered_events
    end


  end
