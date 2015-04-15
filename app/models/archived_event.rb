class ArchivedEvent < ActiveRecord::Base
  # Moves expired events from events table to archived_events table.
  # Deletes them after moving.
  def self.archive
    Event.expired.each do |event|
      ArchivedEvent.new(event.attributes)
      event.destroy
    end
  end
end
