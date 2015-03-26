class Filter

  attr_reader :events	

  def initialize(whichType, user_id, location, tag)
  	   @events = []
       if whichType == "location"
          lat, lng = location.split(",")
          @events = filterByLocation(lat, lng)
       elsif whichType == "time"
          @events = filterByTime(Time.now)
       elsif whichType == "user"
          @events = filterByUser(user_id)
       elsif whichType == "tag"
          @events = filterByTag(tag)
       end
  end

  def filterByTag(tag)
    puts "********************************"
    puts tag
    events_tag = EventTag.where(tag_name: tag)
    events = []
    events_tag.each do |et|
      temp_event = Event.find_by(id: et.event_id)
      if temp_event 
          events.push(temp_event)
      end
    end
    events
  end

  def filterByTime(time)
      # how do we define "soon" when the maximum amount of hours is 24?
      # we will use a reasonable definition of 4 hours
      # subtract five hours because of ETS to UTC conversion
      events = Event.where(time_occurrence: (Time.now-5.hours)..(Time.now-1.hours))
      #@events = Event.where(time_occurrence: (Time.now)..(Time.now+4.hours))
      events
  end

  def filterByUser(user)
     events = Event.where(creator_id: user)
     events
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