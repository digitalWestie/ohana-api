class MailAddressSerializer < ActiveModel::Serializer
  attributes :id, :attention, :street, :city, :postcode
end
