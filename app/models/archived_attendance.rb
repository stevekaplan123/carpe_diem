class ArchivedAttendance < ActiveRecord::Base
  belongs_to :archived_event
  belongs_to :user
end
