class ArchivedEvent < ActiveRecord::Base
  # Move expired events from events table to archived_events table
  def self.archive
    Event.expired.each { |event| ArchivedEvent.new(event.attributes) }
  end
end
