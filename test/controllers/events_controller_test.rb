require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
    
    #now = DateTime.now
    #now.utc_offset
    #test_time = DateTime.new(now.year, now.month, now.day, now.hour, now.min, now.sec)
    @now = DateTime.now
    #puts "woo: #{@now}"
    @update = {
    
        event_name: 'Some Event',
        time_occurrence: @now,
        location: 'Some School',
        description: 'Some Place'
    
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
        #post :create, event: { creator_id: @event.creator_id, description: @event.description, event_name: @event.event_name, latitude: @event.latitude, location: @event.location, longitude: @event.longitude,  time_occurrence: @event.time_occurrence }
        post :create, event: @update
        
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event
    assert_response :success
  end

  test "should update event" do
    patch :update, id: @event, event: @update
      #patch :update, id: @event, event: { creator_id: @event.creator_id, description: @event.description, event_name: @event.event_name, latitude: @event.latitude, location: @event.location, longitude: @event.longitude,  time_occurrence: @event.time_occurrence }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to events_path
  end
end
