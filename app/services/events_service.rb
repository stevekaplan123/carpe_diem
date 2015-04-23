class EventsService

  def self.create_time(params)
    puts "called"
    day_int = params[:event_day].to_date
    event_day = DateTime.new(day_int.year, day_int.month, day_int.day, 1, 1, 1)
    thehour = params[:usertime]["hourmin(4i)"].to_i
    themin = params[:usertime]["hourmin(5i)"].to_i
    DateTime.new(event_day.year, event_day.month, event_day.day, thehour, themin, 59)
  end

  def self.get_tag_string(tag_array)
    if !tag_array.nil?
      tag_array.join(",")
    else
      ""
    end
  end

  def self.update_event_tags(old_event_tags, new_tags_array)
       destroy_array = []
        old_event_tags.each do |old_etag|
          if new_tags_array==nil or new_tags_array.include?(old_etag["tag_id"]) == false
            destroy_array.push(old_etag["tag_id"])
          end
        end
        destroy_array.each do |tid|
          EventTag.where(event_id: params[:id]).find_by(tag_id: tid).destroy
        end
        if new_tags_array != nil
          new_tags_array.each do |new_tid|
            if old_event_tags.find_by(tag_id: new_tid) == nil
              @event.event_tags.create(event_id: params[:id], event_name: params[:event][:name], tag_id: new_tid, tag_name: Tag.find(new_tid).name)
            end
          end
        end
  end

end
