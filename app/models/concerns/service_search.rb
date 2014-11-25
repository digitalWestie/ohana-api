module ServiceSearch
  extend ActiveSupport::Concern
  included do
    #scope :keyword, ->(keyword) { keyword_search(keyword) }
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
end