class AddressSerializer < ActiveModel::Serializer
  attributes :id, :street_1, :street_2, :city, :uprn, :postal_code
end
