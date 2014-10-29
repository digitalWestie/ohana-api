class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.references :service, index: true
      t.references :location, index: true
      t.text :hours

      t.timestamps
    end
  end
end
