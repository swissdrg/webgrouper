require 'db/seed_helpers'
include SeedHelpers
Chop.delete_all
conn.exec("SELECT * FROM classifications.chops").each do |row|
  save_code(Chop, row)
end
puts "Created #{Chop.count} chop entries!"