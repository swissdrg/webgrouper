require 'db/seed_helpers'
include SeedHelpers
Icd.delete_all
conn.exec("SELECT * FROM classifications.icds").each do |row|
  save_code(Icd, row)
end
puts "Created #{Icd.count} icd entries!"