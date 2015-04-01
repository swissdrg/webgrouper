require 'db/seed_helpers'
include SeedHelpers
bar = make_progress_bar('chops')

Chop.delete_all
iterate_table('chops') do |row|
  save_code(Chop, row)
  bar.increment
end
puts "Created #{Chop.count} chop entries!"