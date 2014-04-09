require 'db/seed_helpers'
include SeedHelpers
SupplementDescription.delete_all
conn.exec("SELECT * FROM classifications.supplement_descriptions").each do |row|
  save_code(SupplementDescription, row)
end
puts "Created #{SupplementDescription.count} supplement description entries!"