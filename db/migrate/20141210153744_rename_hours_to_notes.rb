class RenameHoursToNotes < ActiveRecord::Migration
  def change
    rename_column :availabilities, :hours, :notes
  end
end
