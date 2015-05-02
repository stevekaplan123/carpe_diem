class ArchivedAttendance < ActiveRecord::Base
  belongs_to :archived_event, :foreign_key => :event_id
  belongs_to :user
end
