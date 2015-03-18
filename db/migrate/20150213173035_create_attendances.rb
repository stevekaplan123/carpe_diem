class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.belongs_to :event
      t.belongs_to :user
      t.integer :event_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
