class AddAvailabilityIdToSchedules < ActiveRecord::Migration
  def change
    add_column :regular_schedules, :availability_id, :integer
    add_column :holiday_schedules, :availability_id, :integer
  end
end
