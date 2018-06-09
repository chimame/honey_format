require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
email,name,age,country
john@example.com,John Doe,42,SE
CSV

puts '== EXAMPLE: Anonymize by removing columns from output =='
puts
puts '== CSV START =='
csv = HoneyFormat::CSV.new(csv_string)
csv.to_csv(columns: [:age, :country]).tap do |string|
  puts string
end
puts '== CSV END =='
puts
puts
puts '== EXAMPLE: Anonymize by anonymizing the data using a custom row builder =='
puts
puts '== CSV START =='
class Anonymizer
  def call(row)
    # Return an object you want to represent the row
    row.tap do |r|
      r.name = '<anon>'
      r.email = 'anon@example.com'
    end
  end
end
csv = HoneyFormat::CSV.new(csv_string, row_builder: Anonymizer.new)
csv.to_csv.tap do |string|
  puts string
end
puts '== CSV END =='
