class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    @admins = Admin.all
  end

  def update_all
    change_count = 0

    params[:admins].each_pair do |id,attributes|
      admin = Admin.find(id)
      admin.super_admin = attributes.has_key?(:super_admin)
      if admin.super_admin_changed?
        change_count += 1
        admin.update_attribute(:super_admin, attributes.has_key?(:super_admin))
      end
    end

    redirect_to admin_admin_users_path, notice: "#{change_count} user(s) updated"
  end

  def destroy
    admin = Admin.find(params[:id])
    email = admin.email
    admin.destroy
    redirect_to admin_admin_users_path, notice: "Admin with email: #{email} deleted"
  end
end
