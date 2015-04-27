class ArchivedEvent < ActiveRecord::Base

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
