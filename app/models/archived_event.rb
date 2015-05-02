class ArchivedEvent < ActiveRecord::Base
  belongs_to :user, :foreign_key => :creator_id

  has_many :archived_attendances
  has_many :users, through: :archived_attendances

  # Moves expired events from events table to archived_events table.
  # Removes attendance of expired events
  def self.archive
    Event.expired.each do |event|
      self.create(event.attributes)
      Attendance.where('event_id = ?', event.id).each do |a|
        ArchivedAttendance.create(a.attributes)
        a.destroy
      end
      event.destroy
    end
  end
end
