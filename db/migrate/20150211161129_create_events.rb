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

      t.timestamps null: false
    end
  end
end
