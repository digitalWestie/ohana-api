class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :accepted_payments, :alternate_name, :audience, :description,
             :eligibility, :email, :fees, :funding_sources, :how_to_apply,
             :keywords, :languages, :name, :required_documents, :service_areas,
             :min_age, :max_age, :status, :website, :wait, :updated_at,
             :availabilities

  has_many :categories

  def availabilities
    result = []
    for availability in object.availabilities

      regular_schedules = object.regular_schedules.where(availability: availability).map do |rs|
        RegularScheduleSerializer.new(rs).serializable_hash
      end

      holiday_schedules = object.holiday_schedules.where(availability: availability).map do |hs|
        HolidayScheduleSerializer.new(hs).serializable_hash
      end

      result << {
        location: availability.location,
        regular_schedules: regular_schedules,
        holiday_schedules: holiday_schedules
      }
    end
    result
  end

end
