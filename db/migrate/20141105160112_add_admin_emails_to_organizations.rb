class AddAdminEmailsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :admin_emails, :text
  end
end
