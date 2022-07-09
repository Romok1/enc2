module CompanyAutocomplete
  TERM_MIN_LENGTH = 2.freeze
  LIMIT = 25.freeze

  def self.autocomplete(term)
    return [] if term.length < TERM_MIN_LENGTH

    Company.except_excluded_companies.match_companies(term).order(:name).limit(LIMIT)
  end
end
