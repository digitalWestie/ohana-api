class Availability < ActiveRecord::Base
  attr_accessible :hours, :location_id
  belongs_to :service
  belongs_to :location

  validates :location_id, uniqueness: {scope: :service_id}, presence: true

  has_many :regular_schedules, dependent: :destroy
  accepts_nested_attributes_for :regular_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :holiday_schedules, dependent: :destroy
  accepts_nested_attributes_for :holiday_schedules,
                                allow_destroy: true, reject_if: :all_blank
end
