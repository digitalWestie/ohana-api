class AddIsApprovedToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :is_approved, :boolean, default: true
  end
end
