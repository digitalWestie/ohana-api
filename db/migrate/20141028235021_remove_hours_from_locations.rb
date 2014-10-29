class RemoveHoursFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :hours
  end
  def down
    add_column :locations, :hours, :text
  end
end
