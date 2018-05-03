require 'spec_helper'
require 'honey_format/convert_header_value'

describe HoneyFormat::ConvertHeaderValue do
  # See https://bugs.ruby-lang.org/issues/10085
  ruby_version_under_2_4 = Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4.0')
  [
    ['first_name', :first_name],
    ['first name', :first_name],
    ['first name (user)', :'first_name(user)'],
    ['first name [user]', :'first_name[user]'],
    ['first name {user}', :'first_name{user}'],
    ['first (user) name', :'first(user)name'],
    ['first [user] name', :'first[user]name'],
    ['first {user} name', :'first{user}name'],
    ['first (user) name', :'first(user)name'],
    ['Billing City', :billing_city],
    ['Total Order Value (ex VAT)', :'total_order_value(ex_vat)'],
    ['VAT#', :'vat#'],
    ['   first_name  ', :first_name],
    ['first-name', :first_name],
    ['USeRnaMe', :username],
    ruby_version_under_2_4 ? ['ÅÄÖ', :'ÅÄÖ'] : ['ÅÄÖ', :'åäö'],
  ].each do |data|
    input, expected = data

    it "converts #{input} to #{expected}" do
      result = described_class.call(input)
      expect(result).to eq(expected)
    end
  end
end