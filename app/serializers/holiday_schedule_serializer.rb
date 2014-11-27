class HolidayScheduleSerializer < ActiveModel::Serializer
  attributes :closed, :start_date, :end_date, :opens_at, :closes_at

  def opens_at
    object.opens_at.strftime('%H:%M') if object.opens_at
  end

  def closes_at
    object.closes_at.strftime('%H:%M') if object.closes_at
  end

  def start_date
    object.start_date.strftime('%F')
  end

  def end_date
    object.end_date.strftime('%F')
  end
end
