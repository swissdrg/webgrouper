require 'db/seed_helpers'
include SeedHelpers
Supplement.delete_all
iterate_table('supplements') do |row|
  save_code(Supplement, row)
end
puts "Created #{Supplement.count} supplement entries!"