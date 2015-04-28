class ArchivedEvent < ActiveRecord::Base
  belongs_to :user, :foreign_key => :creator_id

  # Moves expired events from events table to archived_events table.
  # Removes attendance of expired events
  def self.archive
    Event.expired.each do |event|
      self.create(event.attributes)
      Attendance.delete_all(['event_id = ?', event.id])
      event.destroy
    end
  end
end
