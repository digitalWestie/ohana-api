class Admin
  class ClacksAdminDecorator
    attr_reader :admin

    def initialize(admin)
      @admin = admin
    end

    def locations
      if admin.super_admin?
        Location.pluck(:id, :name, :slug)
      else
        Location.joins(:organization).
          where('organization_id IN (?)', orgs.map(&:first).flatten).
          uniq.pluck(:id, :name, :slug)
      end
    end

    def orgs
      if admin.super_admin?
        Organization.pluck(:id, :name, :slug, :is_approved)
      else
        ids = Organization.search_admins(admin.email).uniq.collect {|o| o.id}
        Organization.where(id: ids).pluck(:id, :name, :slug, :is_approved)
      end
    end

    def programs
      if admin.super_admin?
        Program.pluck(:id, :name)
      else
        Program.joins(:organization).
          where('organization_id IN (?)', orgs.map(&:first).flatten).
          uniq.pluck(:id, :name)
      end
    end

    def services
      if admin.super_admin?
        Service.pluck(:organization_id, :id, :name)
      else
        services = Service.email(admin.email).pluck(:id)
        Service.joins(:organization).
          where('services.organization_id IN (?) or services.id IN (?)', orgs.map(&:first).flatten, services).
          uniq.pluck(:organization_id, :id, :name)
      end
    end

    def allowed_to_access_location?(location)
      locations.flatten.include?(location.id)
    end

    def allowed_to_access_organization?(org)
      orgs.flatten.include?(org.id)
    end

    def allowed_to_access_program?(program)
      programs.flatten.include?(program.id)
    end
  end
end
