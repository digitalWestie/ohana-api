class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street_1, :street_2, :postal_code,
                  :country_code, :uprn
  alias_attribute :town, :city

  belongs_to :location, touch: true

  validates :street_1,
            :city,
            :postal_code,
            :country_code,
            presence: { message: I18n.t('errors.messages.blank_for_address') }

  validates :country_code, length: { maximum: 2, minimum: 2 }

  validates :postal_code, postal_code: true

  auto_strip_attributes :street_1, :street_2, :city, :uprn, :postal_code,
                        :country_code, squish: true

  after_destroy :reset_location_coordinates

  private

  def reset_location_coordinates
    location.update(latitude: nil, longitude: nil)
  end
end
