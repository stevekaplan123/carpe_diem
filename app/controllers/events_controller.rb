require 'time'
require 'byebug'
class EventsController < ApplicationController

  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  # Low efficiency, will have to check the database every time - Leifeng, 03/17
  def show
    @creator = User.find(@event.creator_id).name
    @attendees = []
    @event.attendances.each do |a|
      @attendees.push(User.find(a.user_id).name)
    end

    current_event_id = params[:id]
    @event_tags = EventTag.where(event_id: current_event_id)

  end


  def signup
    event_id = params[:event_id]
    user_id = params[:user_id]

    ## first create/delete an attendance 
    if params[:whatAction]=="1"                              
         #sign up for event
        Attendance.create(event_id: event_id, user_id: user_id)
        @event = Event.find_by(event_id)
        redirect_to @event, notice: "You have successfully signed up for this event."
        
    elsif params[:whatAction]=="0"                            
      #i dont want to go, cancel my attendance from the event
        attendances = Attendance.where(event_id: event_id, user_id: user_id)
        attendances.each do |att|
          att.destroy 
        end
        redirect_to events_url, notice: "You are no longer signed up for this event."
    end
  end

  # GET /events/filter?type=X&arg=Y
  # 'type' is either location, time, or user
  #   in other words, events occurring at nearby location,
  #   event occurring within a few hours, and events created by the same user
  # 'arg' is the current location of user, or current time, or name of user
 def filter
       whichType = params[:type]
       @events = []

       if whichType == "location"
          lat, lng = params[:location].split(",")
          @events = filterByLocation(lat, lng)
       elsif whichType == "time"
          @events = filterByTime(Time.now)
       elsif whichType == "user"
          @events = filterByUser(current_user.id)
       elsif whichType == "tag"
          @events = filterByTag(params[:tag])
       else
          respond_to do |format|
            format.json { redirect_to events_url, notice: 'INVALID FILTERING TYPE.'}
            format.html { redirect_to events_url, notice: 'INVALID FILTERING TYPE.' }
          end

      end

      respond_to do |format|
          format.json { render :json => @events}
      end
  end



  # GET /events/new
  def new
    @event = Event.new
    @tags = Tag.all
  end

  # GET /events/1/edit
  def edit
  	@tags = Tag.all
  end

  # POST /events
  # POST /events.json
  def create

  	@tags = Tag.all
    @event = Event.new(event_params)


	#steps to put data into time_occurrence field
    day_int = params[:event_day].to_date
    event_day = DateTime.new(day_int.year, day_int.month, day_int.day, 1, 1, 1)
    thehour = params[:usertime]["hourmin(4i)"].to_i
    themin = params[:usertime]["hourmin(5i)"].to_i
    @event.time_occurrence = DateTime.new(event_day.year, event_day.month, event_day.day, thehour, themin, 59)

	#steps to put data into :tags field. tag field is comma separated
	puts "all params: #{params}"
	tag_array = params[:tag_ids]
	if !tag_array.nil?
		tag_string = tag_array.join(",")
		@event.tags = tag_string
	end
	puts "size of tag_array: #{tag_array.size}"

    respond_to do |format|
      if @event.save
        increase_num_events(current_user)
        #assign current user's id to created event
        @event.attendances.create(user_id: session[:user_id])

        #adds tags to event_tags table
        tag_array.each do |chosen_tag|
        	@event.event_tags.create(event_id: params[:id], event_name: params[:event][:name], tag_id: chosen_tag.to_i, tag_name: Tag.find(chosen_tag).name)
        end

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
  	@tags = Tag.all
  	
  	puts "these are event_params: #{event_params}"
  	
  	#get updated time from the form
  	day_int = params[:event_day].to_date
    event_day = DateTime.new(day_int.year, day_int.month, day_int.day, 1, 1, 1)
    thehour = params[:usertime]["hourmin(4i)"].to_i
    themin = params[:usertime]["hourmin(5i)"].to_i
    time_occurrence_datetime = DateTime.new(event_day.year, event_day.month, event_day.day, thehour, themin, 59)
  	  	
  	#get updated tags from the form
  	tag_array = params[:tag_ids]
	if !tag_array.nil?
		tag_string = tag_array.join(",")
	else
		tag_string = ""
	end
	#to replace event_params below
	#does not include creator_id
	#does not update event_tags table; do inside @event.update?--find records by event id, edit each one by one
  	updated_params = {"name"=>params[:event][:name], 
  	"location"=>"", 
  	"longitude"=>params[:event][:longitude], 
  	"latitude"=>params[:event][:latitude], 
  	"description"=>params[:event][:description], 
  	"time_occurrence"=>time_occurrence_datetime, 
  	"tags"=>tag_string}
  	 	
    respond_to do |format|
    	#changed from event_params to updated_params
      if @event.update(updated_params)
      	#update event_tags here?
      	#check if num of tags changed--destroy record if less tags are chosen in the update
      	
      	num_newtags = tag_array.length
      	old_event_tags = EventTag.where(event_id: params[:id])
      	num_oldtags = old_event_tags.count
      	#(0..num_oldtags) do ||
      	
      	#end
      	#need to delete event_tag(s)
      	iter = 1
      	
      	if num_newtags < num_oldtags
      		#because can't delete while in loop
      		destroy_array = []
      	
      		old_event_tags.each do |tags|
      			if iter > num_newtags
      				#push for deletion
      				destroy_array.push(tags.id)
      			else
      				#update old event_tag
      				tags.tag_id = tag_array[iter - 1].to_i
    				tags.tag_name = Tag.find(tag_array[iter - 1]).name
    				tags.save
    				iter += 1
      				
      			end     			
      		end
      		
      		destroy_array.each do |id|
      			EventTag.find(id).destroy
      		end
      		
      	
      	#need to create event_tag(s)
      	elsif num_newtags > num_oldtags
      		
      		old_event_tags.each do |tags|
      			#update old event_tag
      			tags.tag_id = tag_array[iter - 1].to_i
    			tags.tag_name = Tag.find(tag_array[iter - 1]).name
    			tags.save
    			iter += 1
      				    			 
      		end  
      			
      		#create new tags
      		curr_tag_array_index = iter - 1
      		(curr_tag_array_index..(num_newtags - 1)).each do |i|
      			puts "i: #{i}"
      			puts "tag_array index: #{tag_array[i]}"
      			@event.event_tags.create(event_id: params[:id], event_name: params[:event][:name], tag_id: tag_array[i].to_i, tag_name: Tag.find(tag_array[i]).name)
      		end
      			     		
      	    	
      	
      	#only update
      	else
      		old_event_tags.each do |tags|
    			tags.tag_id = tag_array[iter - 1].to_i
    			tags.tag_name = Tag.find(tag_array[iter - 1]).name
    			tags.save
    			iter += 1
      		end
      	
      	end
      	
      	
      
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    e_id = @event["id"]

    attendances = Attendance.where(event_id: e_id)
    attendances.each do |att|
        att.destroy
    end          

    event_tags = EventTag.where(event_id: e_id)
    event_tags.each do |etag|
      etag.destroy
    end
    
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully cancelled.' }
      format.json { head :no_content }
    end
  end

  ##Filtering functions start here

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



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      event_params = params.require(:event).permit(:name, :time_occurrence, :location, :longitude, :latitude, :description)
      event_params[:creator_id] = current_user.id
      event_params[:user] = current_user
      event_params
    end

    # when an event is created,
    # increase the num_events in current user by 1
    def increase_num_events(user)
      user.update_attribute(:num_events, user.num_events + 1)
    end

    # Confirms the correct user or admin
    def correct_user
      set_event
      unless @event.user == current_user || is_admin?
        redirect_to root_path
      end
    end
end
