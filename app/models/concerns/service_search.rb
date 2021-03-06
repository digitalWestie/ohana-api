module ServiceSearch
  extend ActiveSupport::Concern
  included do
    scope :keyword, ->(keyword) { keyword_search(keyword) }
    scope :category, ->(category) { joins(:categories).where(categories: { name: category }) }
    
    scope :weekdays, ->(weekdays) { joins(:regular_schedules).where(regular_schedules: { weekday: weekdays }) }

    scope :org_name, (lambda do |org|
      joins(:organization).where('organizations.name @@ :q', q: org)
    end)

    scope :approved, ->(approval) { joins(:organization).where(organizations: { is_approved: approval }) }

    scope :email, (lambda do |email|
      return Service.none unless email.include?('@')
      domain = email.split('@').last
      services = Service.arel_table
      Service.where(services[:admin_emails].matches("%#{email}%"))
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
      if params[:prerequisite_category]
        ids = Service.category(params[:prerequisite_category]).pluck(:id)
        search_relation = Service.where(id: ids)
      end

      search_relation = search_relation.text_search(params)

      if params[:location].present? or params[:lat_lng].present?
        result = is_near(params[:location], params[:lat_lng], params[:radius]).select(:id)
        search_relation = search_relation.where(id: result)
      end

      if params[:is_paid].eql?(true) or params[:is_paid].eql?("true")
        search_relation = search_relation.is_paid
      end

      approval = true
      approval = false if params[:approved].eql?("false")
      search_relation.approved(approval).uniq
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

    def is_paid
      where.not(fees: [nil, '', 'N/A', 'n/a', 'Free'])
    end

    def category_ancestor(ancestor)
      ancestry = Category.where(categories: { name: ancestor }).pluck(:id).map { |id| id.to_s }
      joins(:categories).where(categories: { ancestry: ancestry })
    end

    def allowed_params(params)
      age_range = params.delete(:age_range)
      age_range ||= ""
      age_range = age_range.split(',')
      if age_range.size.eql?(2)
        params[:min_age] = age_range[0]
        params[:max_age] = age_range[1]
      end
      params.slice(:keyword, :activity, :min_age, :max_age, :weekdays, 
        :org_name, :category, :category_ancestor)
    end

  end
end