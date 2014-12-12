class AddAdminEmailsToServices < ActiveRecord::Migration
  def change
    add_column :services, :admin_email, :text
  end
end
