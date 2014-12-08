class LocationSerializer < BasicLocationSerializer
  attributes :urls, :url

  has_many :services, each_serializer: ServiceSerializer
  has_many :regular_schedules
  has_many :holiday_schedules
  has_one :organization

  def url
    api_location_url(object)
  end
end
