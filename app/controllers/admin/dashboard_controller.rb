class Admin
  class DashboardController < ApplicationController
    layout 'admin'

    def index
      redirect_to new_session_path(:admin) unless admin_signed_in?
      @admin = current_admin
      @ad = ClacksAdminDecorator.new(current_admin)
      @unapproved_orgs = Organization.unapproved.count if admin_signed_in? and @admin.super_admin
      @org_count = @ad.orgs_relation.count
      @location_count = @ad.locations.count
      @service_count = @ad.services.count
      @program_count = @ad.programs.count
    end
  end
end
