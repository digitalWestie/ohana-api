class Admin
  class DashboardController < ApplicationController
    layout 'admin'

    def index
      redirect_to new_session_path(:admin) unless admin_signed_in?
      @admin = current_admin
      @unapproved_orgs = Organization.unapproved.count if admin_signed_in? and @admin.super_admin
    end
  end
end
