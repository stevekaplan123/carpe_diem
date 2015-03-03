require 'test_helper'
require 'minitest/autorun'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
   
  describe "event details" do
  
  	before do
  		@some_event = MiniTest::Mock.new
  		@some_event.expect(:name, "Test Event")
  		@some_event.expect(:time_creation, DateTime.now)
  		@some_event.expect(:location, "Shapiro Campus Center")
      desc=""
      for i in 0..1499  #set up maximum length description
        desc+="h "
      end
  		@some_event.expect(:description, desc)
  	
  	end
   	
  	it "stores time in EST" do
  		@some_event.expect(:time_occurrence, DateTime.now)
  		@some_event.time_creation.zone.must_equal "-05:00"
  		@some_event.time_occurrence.zone.must_equal "-05:00"
  	  	
  	end
  	
  	it "should have non-empty required fields" do
  		@some_event.name.wont_be_empty
  		@some_event.location.wont_be_empty
  		@some_event.description.wont_be_empty
  	
  	end
  	
  	it "has a creation time earlier than occurrence time" do
  		@some_event.expect(:time_occurrence, DateTime.now)
  		@some_event.time_creation.must_be :<=, @some_event.time_occurrence
  	
  	end


    it "should have a valid location" do
     Geocoder.coordinates(@some_event.location).wont_be_nil
  end

    it "should not have a description of over 3000 characters" do
      @some_event.description.length.must_be :<=, 3000
  end  

    it "should have a minimum length description of over three words" do
      desc_array = @some_event.description.split(" ")
      desc_array.length.must_be :>=, 3
    end

  end

  
end
