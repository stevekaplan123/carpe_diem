class Event < ActiveRecord::Base
    
    validates :event_name, :location, :description, presence: true
    
    #validates event doesn't occur in the past
    validate :valid_dates
    
    
    #the increment to day will automatically increment the month
    #the default in the form hour does not follow EST -- keep in mind when testing
    def valid_dates
        #now = Time.now
        temp = DateTime.now
        now = temp.change(min: temp.min - 1)

        if time_occurrence < now
            puts "noooo"
            self.errors.add :start_time, 'event cannot occur in the past!'
         #validates event doesn't occur more than 24 hours in the future
         #now.utc_offset
        elsif time_occurrence >= DateTime.new(now.year, now.month, (now.day + 1), now.hour, now.min, now.sec)
            puts "nooo again"
            self.errors.add :start_time, 'event cannot occur more than 24 hours in the future'
        end
    end
    
   
    
    
end
