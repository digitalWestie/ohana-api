class GbPhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    default_message = "#{value} #{I18n.t('errors.messages.invalid_phone')}"

    unless value =~ /(^\+(?!44)[0-9]{7,15}$)|(^(\+440?|0)(([27][0-9]{9}$)|(1[1-9][0-9]{7,8}$)))/
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
