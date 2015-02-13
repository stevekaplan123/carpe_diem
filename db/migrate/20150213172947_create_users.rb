class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :email
      t.integer :num_events
      t.string :geo_info

      t.timestamps null: false
    end
  end
end
