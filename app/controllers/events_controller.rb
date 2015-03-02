require 'time'
class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end


  # GET /events/filter/:type/:arg
  # 'type' is either location, time, or user
  #   in other words, events occurring at nearby location, 
  #   event occurring within a few hours, and events created by the same user
  # 'arg' is the current location of user, or current time, or name of user
  def filter     
    whichType = params[:type]
       @events = []

       if whichType == "location"
          @events = filterByLocation(params[:arg])
       elsif whichType == "time"
          @events = filterByTime(Time.now)
          #should be the following, but for now Time.now will work:
         # @events = filterByTime(params[:arg])
       elsif whichType == "user"
          @events = filterByUser(params[:arg])
       else
          respond_to do |format|
            format.html { redirect_to events_url, notice: 'INVALID FILTERING TYPE.' }
          end
       end
  end

  def calcDistance(orig_coords, end_coords)
    x=orig_coords[0]-end_coords[0]
    y=orig_coords[1]-end_coords[1]
    Math.sqrt(x*x + y*y)
  end

  def filterByLocation(location)
      #  0.008 is distance from North to Theater
      #  0.002 is distance from North to Usdan
      #  0.0036 is distance from Gosman Gym to Usdan 
      #  a reasonable distance to use to discern whether I am "close" to an event
      #  is a distance of 0.0045

      loc_arr = location.split("+")
      locString = loc_arr.join(" ")

      my_coords = Geocoder.coordinates(locString)
      @events = Event.all
      filtered_events = []
      @events.each do |event|
          event_coords = Geocoder.coordinates(event.location)
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
      now_day = time.day
      now_hour = time.hour
      now_min = time.min
      now_time = now_day.to_f+(now_hour.to_f/24)+(now_min.to_f/(60*24))

      filtered_events = []
      
      @events = Event.all
      @events.each do |event|
          then_hour = Time.parse(event.time_occurrence.to_s).strftime("%H")
          then_minute = Time.parse(event.time_occurrence.to_s).strftime("%M")
          then_day = Time.parse(event.time_occurrence.to_s).strftime("%d")

          then_time = then_day.to_f+(then_hour.to_f/24)+(then_minute.to_f/(60*24))
          diff_time = (then_time - now_time)*24

          if (diff_time <= 4) #requires that events that already happened be deleted
             filtered_events.push(event)
          end
      end
      filtered_events
  end

  def filterByUser(user)
     user = user.to_i
     @events = Event.where(creator_id: user)
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

    respond_to do |format|
      if @event.save
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:creator_id, :event_name, :time_creation, :time_occurrence, :location, :longitude, :latitude, :description)
    end
end
