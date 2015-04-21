class Filter

  attr_reader :events	

  def initialize(user_id, location, friends, time)
  	   @events = Event.all

       if location != 0
          lat, lng = location.split(",")
          @events = filterByLocation(lat, lng, location)
       end

       if time != 0
          @events = @events.where(time_occurrence: (Time.now-4.hours)..(Time.now))
       end

       if friends != 0
          @users_friends = Friendship.where(user_id: user_id)
          @users_friends.each do |my_friend|

          end

          @events = @events.where()
       end

  end


  def calcDistance(orig_coords, end_coords)
    x=orig_coords[0]-end_coords[0]
    y=orig_coords[1]-end_coords[1]
    Math.sqrt(x*x + y*y)
  end

  def filterByLocation(lat, lng)
      #  0.008 is distance from North to Theater
      #  0.002 is distance from North to Usdan
      #  0.0036 is distance from Gosman Gym to Usdan
      #  a reasonable distance to use to discern whether I am "close" to an event
      #  is a distance of 0.0045

      my_coords = [lat.to_f, lng.to_f]
      @events = Event.all
      filtered_events = []
      @events.each do |event|
          event_coords = [event.latitude.to_f, event.longitude.to_f]
          dist = calcDistance(my_coords, event_coords)
          if dist <= 0.0045
            filtered_events.push(event)
          end
      end
      filtered_events
  end


end