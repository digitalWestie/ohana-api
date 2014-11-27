class RegularScheduleSerializer < ActiveModel::Serializer
  attributes :weekday, :opens_at, :closes_at

  def opens_at
    object.opens_at.strftime('%H:%M')
  end

  def closes_at
    object.closes_at.strftime('%H:%M')
  end

  def weekday
    Admin::FormHelper::WEEKDAYS[object.weekday - 1]
  end
end
