require 'test_helper'
require 'minitest/autorun'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
   
  describe "event details" do
  
  	before do
  		@some_event = MiniTest::Mock.new
  		@some_event.expect(:event_name, "Test Event")
  		@some_event.expect(:time_creation, DateTime.now)
  		@some_event.expect(:location, "Test Place")
  		@some_event.expect(:description, "Test Description")
  	
  	end
   	
  	it "stores time in EST" do
  		@some_event.expect(:time_occurrence, DateTime.now)
  		@some_event.time_creation.zone.must_equal "-05:00"
  		@some_event.time_occurrence.zone.must_equal "-05:00"
  	  	
  	end
  	
  	it "should have non-empty required fields" do
  		@some_event.event_name.wont_be_empty
  		@some_event.location.wont_be_empty
  		@some_event.description.wont_be_empty
  	
  	end
  	
  	it "has a creation time earlier than occurrence time" do
  		@some_event.expect(:time_occurrence, DateTime.now)
  		@some_event.time_creation.must_be :<=, @some_event.time_occurrence
  	
  	end
  	
  end  
  
end
