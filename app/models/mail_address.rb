class MailAddress < ActiveRecord::Base
  attr_accessible :attention, :city, :state, :street_1, :street_2, :postal_code,
                  :country_code
  alias_attribute :town, :city

  belongs_to :location, touch: true

  validates :street_1,
            :city,
            :postal_code,
            :country_code,
            presence: { message: I18n.t('errors.messages.blank_for_mail_address') }

  validates :country_code, length: { maximum: 2, minimum: 2 }

  validates :postal_code, postal_code: true

  auto_strip_attributes :street_1, :street_2, :city, :state, :postal_code,
                        :country_code, :attention, squish: true
end
