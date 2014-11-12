class LocaliseAddressesToUk < ActiveRecord::Migration
  def change
    add_column :addresses, :uprn, :string
    rename_column :addresses, :zip, :postcode
    rename_column :mail_addresses, :zip, :postcode
  end
end
