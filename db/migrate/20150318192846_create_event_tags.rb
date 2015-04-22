class CreateEventTags < ActiveRecord::Migration
  def change
    create_table :event_tags do |t|
      t.integer :event_id
      t.integer :tag_id
      t.string :event_name
      t.string :tag_name
      
      t.timestamps null: false
    end
  end
end
