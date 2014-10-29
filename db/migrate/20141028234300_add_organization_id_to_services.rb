class AddOrganizationIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :organization_id, :integer
    add_index :services, :organization_id
  end
end
