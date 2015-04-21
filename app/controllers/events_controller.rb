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

  def signup
    event_id = params[:event_id]
    user_id = params[:user_id]

    ## first create/delete an attendance 
    if params[:whatAction]=="1"                              
         #sign up for event
        Attendance.create(event_id: event_id, user_id: user_id)
        @event = Event.find_by(id: event_id)
        redirect_to @event, notice: "You have successfully signed up for this event."
        
    elsif params[:whatAction]=="0"                            
      #i dont want to go, cancel my attendance from the event
        attendances = Attendance.where(event_id: event_id, user_id: user_id)
        attendances.each do |att|
          att.destroy 
        end
        @event = Event.find_by(id: event_id)
        redirect_to @event, notice: "You are no longer signed up for this event."
    end
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

  # GET /events/filter?args
 def filter
       filter_events = Filter.new(params[:type], current_user.id, params[:location], params[:tag])
       @events = filter_events.archive_old_events
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
  def get_tag_string(tag_array)
    if !tag_array.nil?
      tag_array.join(",")
    else
      ""
    end
  end

  def create_time(params)
    day_int = params[:event_day].to_date
    event_day = DateTime.new(day_int.year, day_int.month, day_int.day, 1, 1, 1)
    thehour = params[:usertime]["hourmin(4i)"].to_i
    themin = params[:usertime]["hourmin(5i)"].to_i
    DateTime.new(event_day.year, event_day.month, event_day.day, thehour, themin, 59)
  end

  def create
    @tags = Tag.all
    @event = Event.new(event_params)
    @event.time_occurrence = create_time(params)
    tag_array = params[:tag_ids]
    tag_string = get_tag_string(tag_array)
    @event.tags = tag_string

    respond_to do |format|
      if @event.save
        increase_num_events(current_user)
        @event.attendances.create(user_id: session[:user_id])         #assign current user's id to created event

        tag_array.each do |chosen_tag|         #adds tags to event_tags table
          @event.event_tags.create(event_id: params[:id], event_name: params[:event][:name], tag_id: chosen_tag.to_i, tag_name: Tag.find(chosen_tag).name)
        end

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
          error_msg = "ERROR: "
          @event.errors.full_messages.each do |msg|
            error_msg += msg+"; "
          end
        format.html { redirect_to "/events/new", notice: error_msg }  #was render :new
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @tags = Tag.all    
    time_occurrence_datetime = create_time(params)
    new_tags_array = params[:tag_ids]
    tag_string = get_tag_string(new_tags_array)
    updated_params = {"name"=>params[:event][:name],   #does not update event tags, see code below 
    "location"=>"", 
    "longitude"=>params[:event][:longitude], 
    "latitude"=>params[:event][:latitude], 
    "description"=>params[:event][:description], 
    "time_occurrence"=>time_occurrence_datetime, 
    "tags"=>tag_string}    
    old_event_tags = EventTag.where(event_id: params[:id])

    respond_to do |format|
      #changed from event_params to updated_params
      if @event.update(updated_params)
        destroy_array = []
        old_event_tags.each do |old_etag|
          if new_tags_array.include?(old_etag["tag_id"]) == false
            puts "going to destroy "+old_etag["tag_id"].to_s
            destroy_array.push(old_etag["tag_id"])
          end
        end
        destroy_array.each do |tid|
          EventTag.where(event_id: params[:id]).find_by(tag_id: tid).destroy
        end
        new_tags_array.each do |new_tid|
          if old_event_tags.find_by(tag_id: new_tid) == nil
            @event.event_tags.create(event_id: params[:id], event_name: params[:event][:name], tag_id: new_tid, tag_name: Tag.find(new_tid).name)
          end
        end
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
          error_msg = "ERROR: "
          @event.errors.full_messages.each do |msg|
            error_msg += msg+"; "
          end
        format.html { redirect_to "/events/"+params[:id]+"/edit", notice: error_msg }
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
      format.html { redirect_to events_url, alert: 'Event was successfully cancelled.' }
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

