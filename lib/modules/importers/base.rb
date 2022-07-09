# frozen_string_literal: true

require 'csv'

module Importers
  class Base
    IMPORT_LOCALES = %w[
      es
      rt
    ].freeze

    def initialize
      p 'Importing...'
    end

    class << self
      def import
        raise 'Not implemented.'
      end
    end
  end
end
