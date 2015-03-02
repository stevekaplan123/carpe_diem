class RemoveTimeCreationFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :time_creation, :datetime
  end
end
