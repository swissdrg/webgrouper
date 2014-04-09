require 'db/seed_helpers'
include SeedHelpers
bar = make_progress_bar('chops')

Chop.delete_all
conn.exec("SELECT * FROM classifications.chops").each do |row|
  save_code(Chop, row)
  bar.increment
end
puts "Created #{Chop.count} chop entries!"