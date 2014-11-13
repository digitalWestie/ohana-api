class MakeGbDefaultCountryForMailAddress < ActiveRecord::Migration
  def up
    change_column :mail_addresses, :country_code, :string, null: false, default: 'GB'
  end

  def down
    change_column :mail_addresses, :country_code, :string, null: false, default: nil
  end
end
