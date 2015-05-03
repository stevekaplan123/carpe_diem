class EventsService

  def self.convert_words_to_uri(txt)
    if txt != nil
      txt_array = txt.split(" ")
      if txt_array.length > 1
        txt_array.join("_")
      else
        txt
      end
    end
  end

  def self.create_time(params)
    puts "called"

    if (params[:event_day].nil?)
      day_int = nil
      event_day = nil
    else
      
      day_int = params[:event_day].to_date
      event_day = DateTime.new(day_int.year, day_int.month, day_int.day, 1, 1, 1)
    end
 
    if (params[:usertime]["hourmin(4i)"].nil?)
      thehour = nil
    else
      thehour = params[:usertime]["hourmin(4i)"].to_i
    end

    if (params[:usertime]["hourmin(5i)"].nil?)
      themin = nil
    else
      themin = params[:usertime]["hourmin(5i)"].to_i
    end

    if (event_day.nil? || thehour.nil? || themin.nil?)
      return nil
    else
      return DateTime.new(event_day.year, event_day.month, event_day.day, thehour, themin, 59)
    end

    
    
  end

  def self.get_tag_string(tag_array)
    if !tag_array.nil?
      tag_array.join(",")
    else
      ""
    end
  end

  def self.update_event_tags(params, event, old_event_tags, new_tags_array)
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
              event.event_tags.create(event_id: params[:id], event_name: params[:event][:name], tag_id: new_tid, tag_name: Tag.find(new_tid).name)
            end
          end
        end
  end

end
