class Organization < ActiveRecord::Base
  default_scope { order('id DESC') }

  attr_accessible :accreditations, :admin_emails, :alternate_name, :date_incorporated,
                  :description, :email, :funding_sources, :legal_status,
                  :licenses, :name, :tax_id, :tax_status, :website

  has_many :locations, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :services, dependent: :destroy

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_org') },
            uniqueness: { case_sensitive: false }

  validates :description,
            presence: { message: I18n.t('errors.messages.blank_for_org') }

  validates :email, email: true, allow_blank: true
  validates :website, url: true, allow_blank: true

  validates :accreditations, :funding_sources, :licenses, pg_array: true
  validates :admin_emails, array: { email: true }

  auto_strip_attributes :alternate_name, :description, :email, :legal_status,
                        :name, :tax_id, :tax_status, :website

  extend FriendlyId
  friendly_id :name, use: [:history]

  after_save :touch_locations, if: :name_changed?

  extend Enumerize
  # List of admin emails that should have access to edit a location's info.
  # Admin emails can be added to a location via the Admin interface.
  serialize :admin_emails, Array
  auto_strip_attributes :admin_emails

  private

  def touch_locations
    locations.find_each(&:touch)
  end
end
