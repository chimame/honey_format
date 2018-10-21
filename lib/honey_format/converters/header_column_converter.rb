# frozen_string_literal: true

module HoneyFormat
  # Header column converter
  module HeaderColumnConverter
    # Bracket character matcher
    BRACKETS = /\(|\[|\{|\)|\]|\}/

    # Separator characters
    SEPS = /'|"|\||\*|\^|\&|%|\$|€|#/

    # Space characters
    SPACES = /[[:space:]]+/

    # Replace map
    REPLACE_MAP = [
      [/\\/, '/'],     # replace "\" with "/"
      [/ \(/, '('],    # replace " (" with "("
      [/ \[/, '['],    # replace " [" with "["
      [/ \{/, '{'],    # replace " {" with "{"
      [/ \{/, '{'],    # replace " {" with "{"
      [/\) /, ')'],    # replace ") " with ")"
      [/\] /, ']'],    # replace "] " with "]"
      [/\} /, '}'],    # replace "} " with "}"
      [/@/, '_at_'],   # replace "@' with "_at_"
      [BRACKETS, '_'], # replace (, [, {, ), ] and } with "_"
      [SPACES, '_'],   # replace one or more space chars with "_"
      [/-/, '_'],      # replace "-" with "_"
      [/\.|,/, '_'],   # replace "." and "," with "_"
      [/::/, '_'],     # replace "::" with "_"
      [%r{/}, '_'],    # replace "/" with "_"
      [SEPS, '_'],     # replace separator chars with "_"
      [/_+/, '_'],     # replace one or more "_" with single "_"
      [/\A_+/, ''],    # remove leading "_"
      [/_+\z/, ''],    # remove trailing "_"
    ].map(&:freeze).freeze

    # Returns converted value and mutates the argument.
    # @return [Symbol] the cleaned header column.
    # @param [String, Symbol] column the string to be cleaned.
    # @param [Integer] index the column index.
    # @example Convert simple header
    #     HeaderColumnConverter.call("  User name ") #=> "user_name"
    # @example Convert complex header
    #     HeaderColumnConverter.call(" First name (user)") #=> :'first_name(user)'
    def self.call(column, index = nil)
      if column.nil? || column.empty?
        raise(ArgumentError, "column and column index can't be blank/nil") unless index

        return :"column#{index}"
      end

      column = column.to_s.dup
      column.strip!
      column.downcase!
      REPLACE_MAP.each do |data|
        from, to = data
        column.gsub!(from, to)
      end
      column.to_sym
    end
  end
end
