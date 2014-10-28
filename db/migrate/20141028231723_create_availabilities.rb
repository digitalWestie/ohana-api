class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.references :service_id, index: true
      t.references :location_id, index: true
      t.text :hours

      t.timestamps
    end
  end
end
