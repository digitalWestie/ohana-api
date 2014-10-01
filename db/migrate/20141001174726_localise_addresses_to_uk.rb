class LocaliseAddressesToUk < ActiveRecord::Migration
  def change
    rename_column :addresses, :state, :uprn
    rename_column :addresses, :zip, :postcode
    remove_column :mail_addresses, :state, :text
    rename_column :mail_addresses, :zip, :postcode
  end
end
