require 'db/seed_helpers'
include SeedHelpers
bar = make_progress_bar('chops')

Chop.delete_all
PsqlChop.find_each do |row|
  save_code(Chop, row.attributes)
  bar.increment
end
puts "Created #{Chop.count} chop entries!"