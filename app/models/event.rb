class Event < ActiveRecord::Base
  belongs_to :user, :foreign_key => :creator_id
  has_many :attendances
  has_many :users, through: :attendances
  has_many :event_tags

  validates :name, :description, presence: true
  validates :latitude, :longitude, presence: true

  #validates user selected a spot on the brandeis map OR entered in a valid location in the location field

  #validates event doesn't occur in the past
  validate :valid_dates

  #validates there are not more than 3 tags selected
  validate :num_tags

  scope :expired, -> { where('time_occurrence < ?', DateTime.now) }

  #the increment to day will automatically increment the month
  def valid_dates
    temp = DateTime.now
    #now = temp.change(min: temp.min - 1)
    now = DateTime.new(temp.year, temp.month, temp.day, temp.hour, temp.min - 1, temp.sec)
    puts now
    puts time_occurrence

    if time_occurrence < now
      self.errors.add :start_time, 'event cannot occur in the past!'
      #validates event doesn't occur more than 24 hours in the future
      #now.utc_offset
    elsif time_occurrence >= DateTime.now+1
      self.errors.add :start_time, 'event cannot occur more than 24 hours in the future'
    end
  end

  def num_tags
    if tags.nil?
      self.errors.add :tag_error, ": must select at least 1 tag"
    else
      max = 3
      array_of_tags = tags.split(",")
      if array_of_tags.length > max
        self.errors.add :tag_error, ": cannot select more than #{max} tags"
      end
    end
  end
end
