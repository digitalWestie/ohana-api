class PostalCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.country_code.eql?('GB')
      validator = GbPostalCodeValidator.new(attributes: [attribute])
      validator.validate_each(record, attribute, value)
    else
      validator = ZipValidator.new(attributes: [attribute])
      validator.validate_each(record, attribute, value)
    end
  end
end
