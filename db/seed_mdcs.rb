require 'db/seed_helpers'
include SeedHelpers
Mdc.delete_all
conn.exec("SELECT * FROM classifications.mdcs").each do |row|
  save_code(Mdc, row)
end
puts "Created #{Mdc.count} Mdc entries!"