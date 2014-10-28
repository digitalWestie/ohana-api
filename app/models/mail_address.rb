class MailAddress < ActiveRecord::Base
  attr_accessible :attention, :city, :street_1, :street_2, :postal_code, :country_code
  alias_attribute :town, :city

  belongs_to :location, touch: true

  validates :street_1,
            :street_2,
            :city,
            :postal_code,
            :country_code,
            presence: { message: I18n.t('errors.messages.blank_for_mail_address') }

  validates :country_code, length: { maximum: 2, minimum: 2 }

  auto_strip_attributes :street_1, :street_2, :city, :postal_code,
                        :country_code, squish: true
end
