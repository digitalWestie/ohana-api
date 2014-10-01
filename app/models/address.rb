class Address < ActiveRecord::Base
  attr_accessible :city, :uprn, :street, :zip
  alias_attribute :postcode, :zip
  alias_attribute :town, :city

  belongs_to :location, touch: true

  validates :street,
            :city,
            :zip,
            presence: { message: I18n.t('errors.messages.blank_for_address') }

  #validates_format_of :postcode, :with =>  /^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\s?[0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$$/i, :message => "invalid postcode"

  auto_strip_attributes :street, :city, :uprn, :zip, squish: true
end
