class MailAddressSerializer < ActiveModel::Serializer
  attributes :id, :attention, :street_1, :street_2, :city, :postal_code
end
