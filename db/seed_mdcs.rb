require 'db/seed_helpers'
include SeedHelpers
Mdc.delete_all
iterate_table('mdcs') do |row|
  save_code(Mdc, row, false)
end
puts "Created #{Mdc.count} Mdc entries!"