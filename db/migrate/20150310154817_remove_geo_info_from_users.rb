class RemoveGeoInfoFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :geo_info, :string
  end
end
