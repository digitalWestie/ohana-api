class Availability < ActiveRecord::Base
  attr_accessible :notes, :location_id
  belongs_to :service
  belongs_to :location

  validates :service_id , presence: true, on: :update
  validates :location_id, uniqueness: {scope: :service_id}, presence: true

  has_many :regular_schedules, dependent: :destroy
  accepts_nested_attributes_for :regular_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :holiday_schedules, dependent: :destroy
  accepts_nested_attributes_for :holiday_schedules,
                                allow_destroy: true, reject_if: :all_blank

  after_create :update_location_status

  private

  def update_location_status
    return if location.active == location_services_active?
    location.update_columns(active: location_services_active?)
  end

  def location_services_active?
    location.services.pluck(:status).include?('active')
  end
end