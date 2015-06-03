require 'db/seed_helpers'
include SeedHelpers
bar = make_progress_bar('icds')
Icd.delete_all

PsqlIcd.find_each do |row|
  save_code(Icd, row.attributes)
  bar.increment
end

puts "Created #{Icd.count} icd entries!"
