class RemoveLocationIdFromServices < ActiveRecord::Migration
  def up
    for service in Service.all
      service.availabilities.create(location_id: service.location_id)
    end
    remove_column :services, :location_id
  end

  def down
    add_column :services, :location_id, :integer
  end
end
