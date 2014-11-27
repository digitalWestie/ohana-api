class BasicLocationSerializer < ActiveModel::Serializer
  attributes :id, :active, :accessibility, :admin_emails, :alternate_name,
             :coordinates, :description, :emails, :languages,
             :latitude, :longitude, :name, :short_desc, :slug, :transportation,
             :updated_at

  has_one :address
  has_many :phones

  def accessibility
    object.accessibility.map(&:text)
  end
end
