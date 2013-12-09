require 'db/seed_helpers'
include SeedHelpers
Supplement.delete_all
conn.exec("SELECT * FROM classifications.supplements").each do |row|
  save_code(Supplement, row)
end
puts "Created #{Supplement.count} supplement entries!"