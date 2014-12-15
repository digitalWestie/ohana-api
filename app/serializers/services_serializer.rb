class ServicesSerializer < ServiceSerializer
  attributes :admin_emails
  has_many :availabilities, serializer: AvailabilitiesSerializer
  has_one :organization
end
