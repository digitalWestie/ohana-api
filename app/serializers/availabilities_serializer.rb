class AvailabilitiesSerializer < ActiveModel::Serializer
  has_many :regular_schedules, serializer: RegularScheduleSerializer
  has_many :holiday_schedules, serializer: HolidayScheduleSerializer
  has_one :location, serializer: BasicLocationSerializer
end