class Event < ActiveRecord::Base
    has_many :attendances
    has_many :users, through: :attendances

    
    validates :name, :description, presence: true
    validates :latitude, :longitude, presence: true
    
    #validates user selected a spot on the brandeis map OR entered in a valid location in the location field

    #validates event doesn't occur in the past
    validate :valid_dates
    

    
    #the increment to day will automatically increment the month
    def valid_dates
        temp = DateTime.now
        #now = temp.change(min: temp.min - 1)
        now = DateTime.new(temp.year, temp.month, temp.day, temp.hour, temp.min - 1, temp.sec)
        puts now
        puts time_occurrence

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
