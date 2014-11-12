class Admin
  class ServicesController < ApplicationController
    include Taggable

    before_action :authenticate_admin!
    layout 'admin'

    def index
      @admin_decorator = ClacksAdminDecorator.new(current_admin)
      organizations = Organization.where(id: @admin_decorator.orgs).order('name').includes(:services)
      @organizations = Kaminari.paginate_array(organizations).page(params[:page]).per(params[:per_page])
    end

    def edit
      @organization = Organization.find(params[:organization_id])
      @service = Service.find(params[:id])
      @admin_decorator = ClacksAdminDecorator.new(current_admin)
      @oe_ids = @service.categories.pluck(:oe_id)

      unless @admin_decorator.allowed_to_access_organization?(@organization)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
      @availabilities = @service.availabilities.includes(:location)
      @unassociated_locations = @service.unassociated_locations.select(:name, :id)
    end

    def update
      @service = Service.find(params[:id])
      @organization = Organization.find(params[:organization_id])
      @oe_ids = @service.categories.pluck(:oe_id)

      preprocess_service

      respond_to do |format|
        if @service.update(params[:service])
          format.html do
            redirect_to admin_services_path,
                        notice: 'Service was successfully updated.'
          end
        else
          format.html { render :edit }
        end
      end
    end

    def new
      @admin_decorator = ClacksAdminDecorator.new(current_admin)
      @organization = Organization.find(params[:organization_id])
      @oe_ids = []

      unless @admin_decorator.allowed_to_access_organization?(@organization)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end

      @unassociated_locations = @organization.locations.select(:name, :id)
      @service = Service.new
    end

    def create
      preprocess_service_params

      @organization = Organization.find(params[:organization_id])
      @service = @organization.services.new(params[:service])
      @oe_ids = []

      add_program_to_service_if_authorized

      respond_to do |format|
        if @service.save
          format.html do
            redirect_to admin_services_path,
                        notice: "Service '#{@service.name}' was successfully created."
          end
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      service = Service.find(params[:id])
      service.destroy

      respond_to do |format|
        format.html { redirect_to admin_services_path }
      end
    end

    def confirm_delete_service
      @service_name = params[:service_name]
      @service_id = params[:service_id]
      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def preprocess_service
      preprocess_service_params
      add_program_to_service_if_authorized
    end

    def preprocess_service_params
      #preprocess_availabilities
      shift_and_split_params(params[:service], :funding_sources, :keywords)
    end

    def add_program_to_service_if_authorized
      prog_id = params[:service][:program_id]
      @service.program = nil and return if prog_id.blank?

      if program_ids_for(@service).select { |id| id == prog_id.to_i }.present?
        @service.program_id = prog_id
      end
    end

    def program_ids_for(service)
      @organization.programs.pluck(:id)
    end

    def preprocess_availabilities
      availability_params = params[:service].delete(:availability_attrs)
      availabilities = {}
      i = 0
      availability_params.each do |location_id, data|
        #build up proper :availabilities_attributes params
        availabilities.merge!(index.to_sym => data.merge(location_id: location_id))
        i+=1
      end
      params[:service].merge!(:availabilities_attributes => availabilities)
    end

  end
end
