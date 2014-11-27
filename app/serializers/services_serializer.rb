class ServicesSerializer < ServiceSerializer
  has_many :availabilities, serializer: AvailabilitiesSerializer
  has_one :organization
end
