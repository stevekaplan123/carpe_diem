class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :creator_id
      t.string :event_name
      t.datetime :time_creation
      t.datetime :time_occurrence
      t.string :location
      t.decimal :longitude
      t.decimal :latitude
      t.text :description

      t.timestamps null: false # might need to be set true to enable created_at, check later - Leifeng ,2015/3/2
    end
  end
end
