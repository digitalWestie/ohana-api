class AddAgeRangeToServices < ActiveRecord::Migration
  def change
    add_column :services, :max_age, :integer, default: 100
    add_column :services, :min_age, :integer, default: 0
  end
end
