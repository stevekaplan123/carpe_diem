require 'time'
class EventsController < ApplicationController

  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    eid = params[:eid]
    if params[:user_action] != nil and params[:user_action] == "cancelled"
      @status = "You are no longer signed up for '"+eid+"'."
    elsif params[:user_action] != nil and params[:user_action] == "signed_up"
      @status = "You've signed up for '"+eid+"'."
    else
      @status = ""
    end
   # @attendees = []
   # @event.attendances.each { |a| @attendees.push(a.user) }
  end
# PUT /events/signup?args where args are event_id, whatAction, user_id
  def signup
    event_id = params[:event_id]
    user_id = params[:user_id]
    if params[:whatAction]=="1"       #1 for sign up, 0 for cancel
        Attendance.create(event_id: event_id, user_id: user_id)
        @event = Event.find_by(id: event_id)
        redirect_to "/events?user_action=signed_up&eid="+EventsService.convert_words_to_uri(@event["name"])
    elsif params[:whatAction]=="0"
        attendances = Attendance.where(event_id: event_id, user_id: user_id)
        attendances.each do |att|
          att.destroy
        end
        @event = Event.find_by(id: event_id)
        redirect_to "/events?user_action=cancelled&eid="+EventsService.convert_words_to_uri(@event["name"])
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @attendees = []
    @event.attendances.each { |a| @attendees.push(a.user) }

    @event_tags = []
    EventTag.where(event_id: @event.id).each { |t| @event_tags.push(t.tag_name) }

  end

  # GET /events/filter?args
  def filter
       filter_events = Filter.new(current_user.id, params[:location], params[:near_me], params[:other], params[:time])
       @events = filter_events.events
       @attendances = Attendance.all
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
    @event.time_occurrence = EventsService.create_time(params)
    tag_array = params[:tag_ids]
    tag_string = EventsService.get_tag_string(tag_array)
    @event.tags = tag_string
    respond_to do |format|
      if @event.save
        UserMailer.create_event_email(@event).deliver_now
        increase_num_events(current_user)
        @event.attendances.create(user_id: session[:user_id])         #assign current user's id to created event
        if tag_array != nil
          tag_array.each do |chosen_tag|         #adds tags to event_tags table
            @event.event_tags.create(event_id: params[:id], event_name: params[:event][:name], tag_id: chosen_tag.to_i, tag_name: Tag.find(chosen_tag).name)
          end
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

  def search
    @events = Event.where('description LIKE ?', "%#{params[:search]}%")
    render action: "index"
  end


  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @tags = Tag.all
    time_occurrence_datetime = EventsService.create_time(params)
    new_tags_array = params[:tag_ids]
    tag_string = EventsService.get_tag_string(new_tags_array)
    updated_params = {"name"=>params[:event][:name],   #does not update event tags, see code below
    "location"=>"",
    "longitude"=>params[:event][:longitude],
    "latitude"=>params[:event][:latitude],
    "description"=>params[:event][:description],
    "time_occurrence"=>time_occurrence_datetime,
    "tags"=>tag_string}
    old_event_tags = EventTag.where(event_id: params[:id])
    respond_to do |format|
      if @event.update(updated_params) #changed from event_params to updated_params
          UserMailer.update_event_email(@event).deliver_now
          EventsService.update_event_tags(params, @event, old_event_tags, new_tags_array)
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
    UserMailer.cancel_event_email(@event).deliver_now
    @event.destroy
    respond_to do |format|
      format.html { redirect_to :back, alert: 'Event was successfully cancelled.' }
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
