module ServiceSearch
  extend ActiveSupport::Concern
  included do
    scope :keyword, ->(keyword) { keyword_search(keyword) }

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
      text_search(params).uniq
    end

    def text_search(params = {})
      allowed_params(params).reduce(self) do |relation, (scope_name, value)|
        value.present? ? relation.public_send(scope_name, value) : relation.all
      end
    end

    def status(param)
      where(status: param)
    end

    def allowed_params(params)
      params.slice(:keyword, :status)
    end
  end
end