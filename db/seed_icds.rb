require 'db/seed_helpers'
include SeedHelpers
bar = make_progress_bar('icds')
Icd.delete_all
conn.exec("SELECT * FROM classifications.icds").each do |row|
  save_code(Icd, row)
  bar.increment
end
puts "Created #{Icd.count} icd entries!"
