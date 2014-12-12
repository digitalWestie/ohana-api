class AddAdminEmailsToServices < ActiveRecord::Migration
  def change
    add_column :services, :admin_emails, :text
  end
end
