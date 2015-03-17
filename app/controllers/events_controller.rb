require 'time'
require 'byebug'
class EventsController < ApplicationController

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
    @attendees = []
    Attendance.where(event_id: params[:id]).each do |a|
      @attendees.push(User.find(a.user_id).name)
    end
    @creator = User.find(@event.creator_id).name
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
          @events = filterByUser(params[:user])
        elsif whichType == "attendance"
          @events = filterByAttendance(params[:attending])
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
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    #assign current user's id to created event
    @event.creator_id = session[:user_id]
    
    #puts "event_day in params: #{params[:event_day]}"
    day_int = params[:event_day].to_date
    
    #puts "day int created: #{day_int}"
    event_day = DateTime.new(day_int.year, day_int.month, day_int.day, 1, 1, 1)
    
    #puts "event_day created: #{event_day}"
    
    #puts "let's do a check: #{params[:usertime]}"
    #puts "let's access it: #{params[:usertime]['hourmin(1i)']}"
    thehour = params[:usertime]["hourmin(4i)"].to_i
    
    #puts "thehour created: #{thehour}"
    themin = params[:usertime]["hourmin(5i)"].to_i
    @event.time_occurrence = DateTime.new(event_day.year, event_day.month, event_day.day, thehour, themin, 59)
    puts "here: #{@event.time_occurrence}"

    respond_to do |format|
      if @event.save
        #link attendance to created event
        Attendance.create(event_id: @event.id, user_id: session[:user_id])
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
    respond_to do |format|
      if @event.update(event_params)
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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ##Filtering functions start here
  
  def filterByAttendance(username)
    #in this case the user looked up all events attended by 'username'
    #TO DO...
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

  def filterByTime(time)
      # how do we define "soon" when the maximum amount of hours is 24?
      # we will use a reasonable definition of 4 hours
      # subtract five hours because of ETS to UTC conversion
      @events = Event.where(time_occurrence: (Time.now-5.hours)..(Time.now-1.hours))
      #@events = Event.where(time_occurrence: (Time.now)..(Time.now+4.hours))

  end

  def filterByUser(user)
     user = user.to_i
     @events = Event.where(creator_id: user)
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:creator_id, :name, :time_occurrence, :location, :longitude, :latitude, :description)
    end
end
