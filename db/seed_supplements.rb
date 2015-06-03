require 'db/seed_helpers'
include SeedHelpers
Supplement.delete_all

PsqlSupplement.find_each do |row|
  save_code(Supplement, row.attributes, false)
end
puts "Created #{Supplement.count} supplement entries!"