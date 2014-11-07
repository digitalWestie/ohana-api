class Availability < ActiveRecord::Base
  attr_accessible :hours
  belongs_to :service
  belongs_to :location
  has_many :regular_schedules, dependent: :destroy
  has_many :holiday_schedules, dependent: :destroy
end
