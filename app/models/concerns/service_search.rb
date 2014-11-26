module ServiceSearch
  extend ActiveSupport::Concern
  included do
    scope :keyword, ->(keyword) { keyword_search(keyword) }
    scope :category, ->(category) { joins(:categories).where(categories: { name: category }) }

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

    def status(param)
      where(status: param)
    end

    def allowed_params(params)
      params.slice(:keyword, :status)
    end

    #TODO: add age search, day search

  end
end