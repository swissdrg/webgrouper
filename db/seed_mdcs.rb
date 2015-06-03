require 'db/seed_helpers'
include SeedHelpers
Mdc.delete_all
PsqlMdc.find_each do |row|
  save_code(Mdc, row.attributes, false)
end
puts "Created #{Mdc.count} Mdc entries!"