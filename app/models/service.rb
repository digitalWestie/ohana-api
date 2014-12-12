class Service < ActiveRecord::Base
  attr_accessible :accepted_payments, :alternate_name, :audience, :description,
                  :eligibility, :email, :fees, :funding_sources, :how_to_apply,
                  :keywords, :languages, :name, :required_documents,
                  :service_areas, :status, :website, :wait, :category_ids,
                  :regular_schedules_attributes, :holiday_schedules_attributes,
                  :availabilities_attributes, :min_age, :max_age, :admin_emails

  has_many :availabilities, dependent: :destroy
  has_many :locations, through: :availabilities

  accepts_nested_attributes_for :availabilities, allow_destroy: true, reject_if: :all_blank

  belongs_to :program
  belongs_to :organization

  has_and_belongs_to_many :categories, -> { order('oe_id asc').uniq }

  has_many :regular_schedules, dependent: :destroy
  accepts_nested_attributes_for :regular_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :holiday_schedules, dependent: :destroy
  accepts_nested_attributes_for :holiday_schedules,
                                allow_destroy: true, reject_if: :all_blank

  validates :accepted_payments, :languages, :required_documents, pg_array: true

  validates :email, email: true, allow_blank: true

  validates :name, :description, :how_to_apply, :status,
            presence: { message: I18n.t('errors.messages.blank_for_service') }

  validates :service_areas, array: { service_area: true }

  validates :website, url: true, allow_blank: true
  validates :admin_emails, array: { email: true }

  auto_strip_attributes :alternate_name, :audience, :description, :eligibility,
                        :email, :fees, :how_to_apply, :name, :wait, :status,
                        :website

  auto_strip_attributes :funding_sources, :keywords, :service_areas, :admin_emails,
                        reject_blank: true, nullify: false

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :service_areas, Array
  serialize :admin_emails, Array

  include PgSearch
  pg_search_scope :search_keywords, :against => [:description, :keywords]

  extend Enumerize
  enumerize :status, in: [:active, :defunct, :inactive]

  after_save :update_location_statuses, if: :status_changed?

  def unassociated_locations
    Location.where(:organization_id => self.organization_id).where.not(id: locations)
  end

  # See app/models/concerns/service_search.rb
  include ServiceSearch

  private

  def update_location_statuses
    locations.each { |l| update_location_status(l) }
  end

  def update_location_status(location)
    return if location.active == location_services_active?(location)
    location.update_columns(active: location_services_active?(location))
  end

  def location_services_active?(location)
    location.services.pluck(:status).include?('active')
  end
end
