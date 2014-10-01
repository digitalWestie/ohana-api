class AddressSerializer < ActiveModel::Serializer
  attributes :id, :street, :city, :uprn, :postcode
end
