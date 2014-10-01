class LocaliseAddressesToUk < ActiveRecord::Migration
  def change
    rename_column :addresses, :state, :uprn
    remove_column :mail_addresses, :state, :text
  end
end
