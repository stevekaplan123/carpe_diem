every 1.day, :at => '11:59 pm' do
  runner "ArchivedEvent.archive"
end
