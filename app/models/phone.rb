class Phone < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :country_prefix, :department, :extension, :number,
                  :number_type, :vanity_number

  belongs_to :location, touch: true
  belongs_to :contact, touch: true

  validates :number,
            presence: { message: I18n.t('errors.messages.blank_for_phone') },
            gb_phone: true #phone.number == '711' } }

  validates :number_type,
            presence: { message: I18n.t('errors.messages.blank_for_phone') }

  validates :extension, numericality: { allow_nil: true }

  auto_strip_attributes :country_prefix, :department, :extension, :number,
                        :vanity_number, squish: true

  extend Enumerize
  enumerize :number_type, in: [:voice, :fax, :hotline, :tty]
end
