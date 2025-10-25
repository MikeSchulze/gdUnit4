# frozen_string_literal: true

module Sass
  # Contextual information passed to `canonicalize` and `find_file_url`.
  # Not all importers will need this information to resolve loads, but some may find it useful.
  #
  # @see https://sass-lang.com/documentation/js-api/interfaces/canonicalizecontext/
  class CanonicalizeContext
    # @return [String, nil]
    def containing_url
      @containing_url_unused = false
      @containing_url
    end

    # @return [Boolean]
    attr_reader :from_import

    # @!visibility private
    def initialize(canonicalize_request)
      @containing_url_unused = true
      @containing_url = canonicalize_request.containing_url == '' ? nil : canonicalize_request.containing_url
      @from_import = canonicalize_request.from_import
    end
  end
end
