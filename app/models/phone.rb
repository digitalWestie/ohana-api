class Phone < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :department, :extension, :number, :number_type,
                  :vanity_number

  belongs_to :location, touch: true

  validates :number,
            presence: { message: I18n.t('errors.messages.blank_for_phone') },
            uk_phone: true #phone.number == '711' } }

  auto_strip_attributes :department, :extension, :number, :number_type,
                        :vanity_number, squish: true
end
