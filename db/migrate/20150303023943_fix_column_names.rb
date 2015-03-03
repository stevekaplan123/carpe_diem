class FixColumnNames < ActiveRecord::Migration
  def change
    rename_column :users, :user_name, :name
    rename_column :events, :event_name, :name
  end
end
