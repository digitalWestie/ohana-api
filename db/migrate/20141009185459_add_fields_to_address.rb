class AddFieldsToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :country_code, :string, null: false, :default => 'GB'
    add_column :addresses, :street_2, :string
    rename_column :addresses, :postcode, :postal_code
    rename_column :addresses, :street, :street_1
  end
end
