class CreateArchivedEvents < ActiveRecord::Migration
  def change
    create_table :archived_events do |t|
      t.belongs_to :user
      t.integer :creator_id
      t.string :name
      t.datetime :time_occurrence
      t.string :location
      t.decimal :longitude
      t.decimal :latitude
      t.text :description
      t.string :tags

      t.timestamps null: false
    end
  end
end
