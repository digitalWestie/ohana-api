module ServiceSearch
  extend ActiveSupport::Concern
  included do
    scope :keyword, ->(keyword) { keyword_search(keyword) }
    scope :category, ->(category) { joins(:categories).where(categories: { name: category }) }
    scope :weekdays, ->(weekdays) { joins(:regular_schedules).where(regular_schedules: { weekday: weekdays }) }

    scope :org_name, (lambda do |org|
      joins(:organization).where('organizations.name @@ :q', q: org)
    end)

    include PgSearch
    pg_search_scope :keyword_search,
      against: :search_vector,
      using: {
        tsearch: {
          dictionary: 'english',
          any_word: false,
          prefix: true,
          tsvector_column: 'search_vector'
      }
    }
  end

  module ClassMethods
    require 'exceptions'

    def search(params = {})
      if params[:location].present? or params[:lat_lng].present?
        result = is_near(params[:location], params[:lat_lng], params[:radius]).select(:id)
        text_search(params).where(id: result).uniq
      else
        text_search(params).uniq
      end
    end

    def text_search(params = {})
      allowed_params(params).reduce(self) do |relation, (scope_name, value)|
        value.present? ? relation.public_send(scope_name, value) : relation.all
      end
    end

    def is_near(loc, lat_lng, radius)
      r = Location.is_near(loc, lat_lng, radius)
      Service.joins(:availabilities).where('availabilities.location_id' => r.map {|l| l.id })
    end

    def activity(param)
      where(status: param)
    end

    def min_age(min=0)
      Service.where('max_age >= ?', min)
    end

    def max_age(max=100)
      Service.where('min_age <= ?', max)
    end

    def is_paid(param)
      where.not(fees: [nil, '', 'N/A', 'Free']) if param
    end

    def allowed_params(params)
      age_range = params.delete(:age_range)
      age_range ||= ""
      age_range = age_range.split(',')
      if age_range.size.eql?(2)
        params[:min_age] = age_range[0]
        params[:max_age] = age_range[1]
      end
      params.delete(:is_paid) if params[:is_paid].blank?
      params.slice(:keyword, :activity, :min_age, :max_age, :weekdays, :org_name, :category, :is_paid)
    end

  end
end